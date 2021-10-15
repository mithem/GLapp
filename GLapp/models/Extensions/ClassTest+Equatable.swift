//
//  ClassTest+Equatable.swift
//  ClassTest+Equatable
//
//  Created by Miguel Themann on 15.10.21.
//

import Foundation

extension ClassTest: Equatable {
    static func == (lhs: ClassTest, rhs: ClassTest) -> Bool {
        return lhs.classTestDate == rhs.classTestDate && lhs.start == rhs.start && lhs.end == rhs.end && lhs.room == rhs.room && lhs.subject == rhs.subject && lhs.teacher == rhs.teacher && lhs.individual == rhs.individual && lhs.opened == rhs.opened && lhs.alias == rhs.alias
    }
}
