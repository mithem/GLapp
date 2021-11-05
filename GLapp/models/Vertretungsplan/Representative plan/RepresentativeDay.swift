//
//  RepresentativeDay.swift
//  RepresentativeDay
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

struct RepresentativeDay: Equatable, Identifiable, Codable, DeliverableByNotification {
    var id: Date? { date }
    
    var lessons: [RepresentativeLesson]
    var date: Date?
    var notes: [String]
    
    init(date: Date? = nil, lessons: [RepresentativeLesson] = [], notes: [String] = []) {
        self.date = date
        self.lessons = lessons
        self.notes = notes
    }
    
    var isEmpty: Bool {
        return lessons.isEmpty && notes.isEmpty
    }
    
    var summary: String {
        var str = lessons.map {$0.summary}.joined(separator: ", ")
        if !notes.isEmpty {
            str.append("; " + notes.joined(separator: ", "))
        }
        return str
    }
    
    var notificationId: KeyPath<Constants.Identifiers.Notifications, String>? { \.reprPlanUpdateNotification }
    
    var title: String { "repr_plan_update" }
    
    var interruptionLevel: NotificationManager.InterruptionLevel {
        var current = NotificationManager.InterruptionLevel.passive
        for lesson in lessons {
            if lesson.interruptionLevel > current {
                current = lesson.interruptionLevel
            }
        }
        return current
    }
    
    var relevance: Double {
        var current = 0.0
        for lesson in lessons {
            if lesson.relevance > current {
                current = lesson.relevance
            }
        }
        return current
    }
}
