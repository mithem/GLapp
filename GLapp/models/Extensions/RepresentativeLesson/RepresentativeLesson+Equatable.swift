//
//  RepresentativeLesson+Equatable.swift
//  GLapp
//
//  Created by Miguel Themann on 09.11.21.
//

import Foundation

extension RepresentativeLesson: Equatable {
    public static func == (_ lhs: RepresentativeLesson, _ rhs: RepresentativeLesson) -> Bool {
        lhs.representativeTeacher == rhs.representativeTeacher && lhs.normalTeacher == rhs.normalTeacher && lhs.subject == rhs.subject && lhs.note == rhs.note && lhs.lesson == rhs.lesson && lhs.date == rhs.date
    }
}
