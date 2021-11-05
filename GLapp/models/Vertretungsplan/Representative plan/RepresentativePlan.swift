//
//  RepresentativePlan.swift
//  RepresentativePlan
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation

struct RepresentativePlan: Codable, DeliverableByNotification {
    var date: Date?
    var representativeDays: [RepresentativeDay]
    var lessons: [RepresentativeLesson]
    var notes: [String]
    var lastFetched: Date
    
    init(date: Date?, representativeDays: [RepresentativeDay] = [], lessons: [RepresentativeLesson] = [], notes: [String] = []) {
        self.date = date
        self.representativeDays = representativeDays
        self.lessons = lessons
        self.notes = notes
        self.lastFetched = .rightNow
    }
    
    var isEmpty: Bool {
        let days = representativeDays.isEmpty || (representativeDays.count == 1 && representativeDays.first?.isEmpty == true)
        let lessons = lessons.isEmpty
        let notes = notes.isEmpty
        return days && lessons && notes
    }
    
    var summary: String {
        var msgs = [String]()
        msgs.append(notes.joined(separator: ", "))
        msgs.append(lessons.map {$0.summary}.joined(separator: ", "))
        msgs.append(representativeDays.map {$0.summary}.joined(separator: ", "))
        return msgs.filter {$0 != ""}.joined(separator: "; ")
    }
    
    var notificationId: KeyPath<Constants.Identifiers.Notifications, String>? { \.reprPlanUpdateNotification }
    
    var title: String { "repr_plan_update" }
    
    var interruptionLevel: NotificationManager.InterruptionLevel {
        var current = NotificationManager.InterruptionLevel.passive
        for day in representativeDays {
            if day.interruptionLevel > current {
                current = day.interruptionLevel
            }
        }
        return current
    }
    
    var relevance: Double {
        var current = 0.0
        for day in representativeDays {
            if day.relevance > current {
                current = day.relevance
            }
        }
        return current
    }
}
