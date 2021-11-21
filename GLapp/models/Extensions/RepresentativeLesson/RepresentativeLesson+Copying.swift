//
//  RepresentativeLesson+Copying.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

extension RepresentativeLesson: Copying {
    func copy() -> RepresentativeLesson {
        .init(date: date, lesson: lesson, room: room, newRoom: newRoom, note: note, subject: subject, normalTeacher: normalTeacher, representativeTeacher: representativeTeacher)
    }
}
