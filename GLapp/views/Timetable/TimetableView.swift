//
//  TimetableView.swift
//  TimetableView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct TimetableView: View {
    @ObservedObject var model: TimetableViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var InnerView: some View {
        VStack {
            DataManagementTaskView(date: model.timetable?.date, lastFetched: model.timetable?.lastFetched, task: model.dataManager.tasks.getTimetable)
            Spacer()
            if let timetable = model.timetable, let grid = model.timetableGrid {
                ScrollView {
                    VStack {
                        if timetable.isEmpty {
                            EmptyContentView(image: "calendar.badge.exclamationmark", text: "timetable_empty")
                        } else {
                            let grid = LazyVGrid(columns: .init(repeating: .init(), count: timetable.weekdays.count)) {
                                ForEach(timetable.weekdays) { weekday in
                                    Text(Constants.weekdayIDStringMap[weekday.id] ?? "unkown")
                                        .font(.headline)
                                }
                                ForEach(grid) { lesson in
                                    LessonInlineView(lesson: lesson, dataManager: model.dataManager)
                                }
                            }
                            if verticalSizeClass == .compact {
                                ScrollView {
                                    grid
                                }
                            } else {
                                grid
                            }
                        }
                    }
                }
                .padding()
            } else {
                AccentColorButton(label: {
                    Text("retry")
                }, action: model.loadTimetable)
            }
            Spacer()
        }
        .onReceive(model.timer) { timer in
            if model.startDate.distance(to: .rightNow) >= Constants.timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated && !model.didDonateUserActivity {
                IntentToHandle.showTimetable.donate()
                model.didDonateUserActivity = true
            }
        }
        .navigationTitle("timetable")
        .toolbar {
            Button(action: model.loadTimetable) {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
    
    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                InnerView
            } else if UIDevice.current.userInterfaceIdiom == .phone {
                NavigationView {
                    InnerView
                }
                .navigationViewStyle(.stack)
            }
        }
    }

    init(dataManager: DataManager) {
        model = .init(dataManager: dataManager)
    }
}

struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView(dataManager: MockDataManager())
    }
}
