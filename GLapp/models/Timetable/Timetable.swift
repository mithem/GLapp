//
//  Timetable.swift
//  Timetable
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

struct Timetable: Equatable {
    var date: Date
    var weekdays: [Weekday]
    //var subjects: [Subject]
    
    var isEmpty: Bool {
        weekdays.isEmpty //&& subjects.isEmpty
    }
    
    var maxHours: Int {
        var max = 0
        for wday in weekdays {
            let tmp = wday.lessons.max(by: { lhs, rhs in
                rhs.lesson > lhs.lesson
            })
            if let tmp = tmp {
                if tmp.lesson > max {
                    max = tmp.lesson
                }
            }
        }
        return max
    }
    
    init(date: Date, weekdays: [Weekday] = [], subjects: [Subject] = []) {
        self.date = date
        self.weekdays = weekdays
        //self.subjects = subjects
    }
}
