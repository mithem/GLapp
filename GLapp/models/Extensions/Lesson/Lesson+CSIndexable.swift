//
//  Lesson+CSIndexable.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension Lesson: CSIndexable {
    var indexItemTitle: String {
        let weekday = String(weekday)
        let weekdayStr: String
        if let weekday = weekday {
            weekdayStr = weekday + " "
        } else {
            weekdayStr = ""
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let lesson = formatter.string(from: NSNumber(value: lesson))
        let lessonStr: String
        if let lesson = lesson {
            lessonStr = lesson + " "
        } else {
            lessonStr = ""
        }
        return "\(weekdayStr)\(lessonStr)\(subject)"
    }
    
    var keywords: [String] {
        ["lesson"]
    }
}
