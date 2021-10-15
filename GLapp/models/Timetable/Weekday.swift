//
//  Weekday.swift
//  Weekday
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

struct Weekday: Identifiable, Equatable {
    /// Weekday number from 0 (Mon) to 6 (Sun)
    var id: Int
    var lessons: [Lesson]
    
    init(id: Int, lessons: [Lesson] = []) {
        self.id = id
        self.lessons = lessons
    }
}
