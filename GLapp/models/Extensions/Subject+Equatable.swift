//
//  Subject+Equatable.swift
//  Subject+Equatable
//
//  Created by Miguel Themann on 18.10.21.
//

import Foundation

extension Subject: Equatable {
    static func == (lhs: Subject, rhs: Subject) -> Bool {
        lhs.className == rhs.className && lhs.subjectName == rhs.subjectName && lhs.subjectType == rhs.subjectType && lhs.teacher == rhs.teacher
    }
}
