//
//  TimetableViewModel.swift
//  TimetableViewModel
//
//  Created by Miguel Themann on 11.10.21.
//

import SwiftUI

final class TimetableViewModel: ObservableObject {
    @ObservedObject var dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    var isLoading: Bool {
        dataManager.tasks.getTimetable.isLoading
    }
    
    var error: GLappError? {
        dataManager.tasks.getTimetable.error
    }
    
    var timetable: Timetable? {
        dataManager.timetable
    }
    
    var timetableGrid: [TimetableViewLesson] {
        guard let timetable = timetable else { return [] }

        var id = 0
        var grid = [TimetableViewLesson]()
        let weekdays: [Weekday] = timetable.weekdays
        var lessons = weekdays.map({$0.lessons as [Lesson?]})
        for i in 0 ..< lessons.count {
            var prev: Lesson? = nil
            var runningDif = 0
            var j = 0
            while j + runningDif < lessons[i].count {
                if let lesson = lessons[i][j + runningDif] {
                    let dif = lesson.lesson - (prev?.lesson ?? 0) - 1
                    if dif > 0 {
                        for _ in 0 ..< dif { // pad leading & in-between free lessons
                            lessons[i].insert(nil, at: j + runningDif)
                        }
                        runningDif += dif
                    }
                    prev = lesson
                }
                j += 1
            }
            for _ in (prev?.lesson ?? 0) ..< timetable.maxHours { // pad trailing "free lessons"
                lessons[i].append(nil)
            }
        }
        for i in 0 ..< timetable.maxHours { // row-wise traversing (ith lesson any day)
            for n in 0 ..< lessons.count { // column-wise traversing (nth weekday)
                if i >= lessons[n].count {
                    continue
                }
                grid.append(.init(id: id, lesson: lessons[n][i]))
                id += 1
            }
        }
        return grid
    }
    
    var gridItems: [GridItem] {
        let items: [GridItem] = .init(repeating: .init(), count: timetable?.weekdays.count ?? 0)
        return items
    }
    
    func loadTimetable() {
        dataManager.loadTimetable(withHapticFeedback: true)
    }
    
    final class TimetableViewLesson: ObservableObject, Identifiable {
        @Published var id: Int
        @Published var lesson: Lesson?
        
        init(id: Int, lesson: Lesson?) {
            self.id = id
            self.lesson = lesson
        }
    }
}
