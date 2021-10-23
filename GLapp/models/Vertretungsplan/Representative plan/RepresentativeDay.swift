//
//  RepresentativeDay.swift
//  RepresentativeDay
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

struct RepresentativeDay: Equatable, Identifiable {
    var id: Date? { date }
    
    var lessons: [RepresentativeLesson]
    var date: Date?
    
    init(date: Date? = nil, lessons: [RepresentativeLesson] = []) {
        self.date = date
        self.lessons = lessons
    }
    
    var isEmpty: Bool {
        return lessons.isEmpty
    }
}