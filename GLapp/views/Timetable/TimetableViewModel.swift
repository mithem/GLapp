//
//  TimetableViewModel.swift
//  TimetableViewModel
//
//  Created by Miguel Themann on 11.10.21.
//

import SwiftUI
import Combine

final class TimetableViewModel: ObservableObject {
    @ObservedObject var dataManager: DataManager
    @Published var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private let startDate: Date
    private var didDonateIntent: Bool
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        timer = Timer.publish(every: Constants.timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated, tolerance: nil, on: .current, in: .common).autoconnect()
        startDate = .rightNow
        didDonateIntent = false
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
    
    func reload() {
        dataManager.loadTimetable(withHapticFeedback: true)
        donateIntent(force: true)
    }
    
    ///Donate intent if appropriate.
    ///
    /// Donate if:
    /// - user has spent a reasonable amount of time on screen
    /// - did not already donate an intent
    /// - Parameter force: donate (if haven't already) even if the 'reasonable' amount of time on screen hasn't passed yet. Useful for e.g. refresh actions.
    func donateIntent(force: Bool = false) {
        if (startDate.distance(to: .rightNow) >= Constants.timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated || force) && !didDonateIntent {
            IntentToHandle.showTimetable.donate()
            didDonateIntent = true
        }
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
