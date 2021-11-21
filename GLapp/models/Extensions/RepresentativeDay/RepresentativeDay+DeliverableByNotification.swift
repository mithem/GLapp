//
//  RepresentativeDay+DeliverableByNotification.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension RepresentativeDay: DeliverableByNotification {
    var notificationSummary: String {
        var str = lessons.map {$0.notificationSummary}.joined(separator: ", ")
        if !notes.isEmpty {
            str.append("; " + notes.joined(separator: ", "))
        }
        return str
    }
    
    var notificationId: KeyPath<Constants.Identifiers.Notifications, String>? { \.reprPlanUpdateNotification }
    
    var notificationTitle: String { "repr_plan_update" }
    
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
