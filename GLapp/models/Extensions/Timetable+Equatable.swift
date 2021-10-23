//
//  Timetable+Equatable.swift
//  Timetable+Equatable
//
//  Created by Miguel Themann on 19.10.21.
//

import Foundation

extension Timetable: Equatable {
    static func == (lhs: Timetable, rhs: Timetable) -> Bool {
        lhs.date == rhs.date && lhs.weekdays == rhs.weekdays
    }
}
