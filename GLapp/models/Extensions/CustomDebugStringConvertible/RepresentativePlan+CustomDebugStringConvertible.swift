//
//  RepresentativePlan+CustomDebugStringConvertible.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

#if DEBUG
extension RepresentativePlan: CustomDebugStringConvertible {
    var debugDescription: String {
        "RepresentativePlan(date: \(String(describing: date)), lastFetched: \(lastFetched), notes: [\(notes.map {"\"\($0)\""}.joined(separator: ", "))], days: [\(representativeDays.map {$0.debugDescription}.joined(separator: ", "))], lessons: [\(lessons.map {$0.debugDescription}.joined(separator: ", "))]"
    }
}
#endif
