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
        return "RepresentativeLesson(date: \(date), lesson: \(lesson), room: \(String(describing: room)), newRoom: \(String(describing: newRoom)), normalTeacher: \(String(describing: normalTeacher)), reprTeacher: \(String(describing: representativeTeacher)), subject: \(String(describing: subject))"
    }
}
#endif
