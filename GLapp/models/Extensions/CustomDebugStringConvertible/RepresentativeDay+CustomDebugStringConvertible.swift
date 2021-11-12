//
//  RepresentativeDay+CustomDebugStringConvertible.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

#if DEBUG
extension RepresentativeDay: CustomDebugStringConvertible {
    var debugDescription: String {
        "RepresentativeDay(date: \(String(describing: date)), notes: [\(notes.map {"\"\($0)\""}.joined(separator: ", "))], lessons: [\(lessons.map {$0.debugDescription}.joined(separator: ", "))])"
    }
}
#endif
