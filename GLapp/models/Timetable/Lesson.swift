//
//  Lesson.swift
//  Lesson
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

struct Lesson: Identifiable, Equatable {
    var id: Int { lesson }
    
    var lesson: Int
    var room: String
    var subject: Subject
}
