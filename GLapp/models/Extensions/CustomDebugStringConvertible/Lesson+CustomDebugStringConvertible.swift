//
//  Lesson+CustomDebugStringConvertible.swift
//  GLapp
//
//  Created by Miguel Themann on 02.11.21.
//

import Foundation

#if DEBUG
extension Lesson: CustomDebugStringConvertible {
    var debugDescription: String {
        "Lesson(lesson: \(lesson), room: \(room), subject: \(subject))"
    }
}
#endif
