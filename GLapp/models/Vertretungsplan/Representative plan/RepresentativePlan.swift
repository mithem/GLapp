//
//  RepresentativePlan.swift
//  RepresentativePlan
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

struct RepresentativePlan: Equatable {
    var date: Date
    var representativeDays: [RepresentativeDay]
    var lessons: [RepresentativeLesson]
    var notes: [String]
    
    init(date: Date) {
        representativeDays = []
        lessons = []
        notes = []
        self.date = date
    }
    
    init(date: Date, representativeDays: [RepresentativeDay] = [], lessons: [RepresentativeLesson], notes: [String]) {
        self.date = date
        self.representativeDays = representativeDays
        self.lessons = lessons
        self.notes = notes
    }
    
    var isEmpty: Bool {
        let days = representativeDays.isEmpty || (representativeDays.count == 1 && representativeDays.first?.isEmpty == true)
        let lessons = lessons.isEmpty
        let notes = notes.isEmpty
        return days && lessons && notes
    }
}
