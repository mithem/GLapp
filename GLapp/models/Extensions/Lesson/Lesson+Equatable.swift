//
//  Lesson+Equatable.swift
//  Lesson+Equatable
//
//  Created by Miguel Themann on 18.10.21.
//

import Foundation

extension Lesson: Equatable {
    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        lhs.lesson == rhs.lesson && lhs.room == rhs.room && lhs.subject == rhs.subject
    }
}
