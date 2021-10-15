//
//  RepresentativeLesson.swift
//  RepresentativeLesson
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

struct RepresentativeLesson: Equatable, Identifiable {
    var id: Date { date }
    
    var date: Date
    var lesson: Int
    var room: String?
    var newRoom: String?
    var note: String?
    var subject: Subject
}
