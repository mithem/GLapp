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
            if model.appManager.demoMode.isEnabled.unwrapped {
                DemoModeWarningView(appManager: model.appManager, dataManager: model.dataManager)
            }
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
                                    Text(GLDateFormatter.localFormatter.shortWeekdaySymbols[weekday.id])
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
                }) {
                    model.reload()
                }
            }
            Spacer()
        }
        .onReceive(model.timer) { timer in
            model.donateIntent()
        }
        .navigationTitle("timetable")
        .toolbar {
            Button(action: {
                model.reload()
            }) {
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

    init(appManager: AppManager, dataManager: DataManager) {
        model = .init(appManager: appManager, dataManager: dataManager)
    }
}

#if DEBUG
struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView(appManager: .init(), dataManager: MockDataManager())
    }
}
#endif
