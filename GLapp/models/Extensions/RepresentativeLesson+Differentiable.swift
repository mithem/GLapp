//
//  RepresentativeLesson+Differentiable.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

extension RepresentativeLesson: Differentiable {
    static func difference(_ lhs: RepresentativeLesson, to rhs: RepresentativeLesson) -> RepresentativeLesson {
        return difference(of: lhs, to: rhs).newLesson(old: rhs)
    }
    
    static func difference(of lhs: RepresentativeLesson, to rhs: RepresentativeLesson) -> RepresentativeLesson.Difference {
        var difference = RepresentativeLesson.Difference()
        if rhs.room != lhs.room {
            difference.room = lhs.room
        }
        if rhs.newRoom != lhs.newRoom {
            difference.newRoom = lhs.newRoom
        }
        if rhs.note != lhs.note {
            difference.note = lhs.note
        }
        return difference
    }
}
