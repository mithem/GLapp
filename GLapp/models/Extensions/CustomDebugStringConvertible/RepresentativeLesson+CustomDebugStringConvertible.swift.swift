//
//  RepresentativeLesson+CustomDebugStringConvertible.swift.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

#if DEBUG
extension RepresentativeLesson: CustomDebugStringConvertible {
    var debugDescription: String {
        "RepresentativeLesson(date: \(date), lesson: \(lesson), room: \(String(describing: room)), newRoom: \(String(describing: newRoom)), normalTeacher: \(normalTeacher), reprTeacher: \(String(describing: representativeTeacher)), subject: \(subject))"
    }
}
#endif
