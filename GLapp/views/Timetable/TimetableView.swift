//
//  TimetableView.swift
//  TimetableView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct TimetableView: View {
    @ObservedObject private var model: TimetableViewModel
    var body: some View {
        NavigationView {
            ZStack {
                if model.isLoading {
                    LoadingView()
                } else if let error = model.error {
                    ErrorView(error: error, callback: model.loadTimetable)
                } else if let timetable = model.timetable, let grid = model.timetableGrid {
                    VStack {
                        HStack {
                            Text("date_colon \(timetable.date.formattedWithLocale)")
                            Spacer()
                        }
                        .padding()
                        Spacer()
                        if timetable.isEmpty {
                            EmptyContentView(image: "calendar.badge.exclamationmark", text: "timetable_empty")
                        } else {
                            LazyVGrid(columns: .init(repeating: .init(), count: 5)) {
                                ForEach(grid) { lesson in
                                    LessonInlineView(lesson: lesson)
                                }
                            }
                        }
                        Spacer()
                    }
                } else {
                    Text("no_data")
                        .onAppear {
                            model.setError(NetworkError.noData, for: \.getTimetable)
                        }
                }
            }
            .padding()
            .navigationTitle("timetable")
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
