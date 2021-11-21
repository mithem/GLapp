//
//  RepresentativePlan+DeliverableByNotification.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension RepresentativePlan: DeliverableByNotification {
    var notificationSummary: String {
        if isEmpty {
            return "representative_plan_empty"
        }
        var msgs = [String]()
        msgs.append(notes.joined(separator: ", "))
        msgs.append(lessons.map {$0.notificationSummary}.joined(separator: ", "))
        msgs.append(representativeDays.map {$0.notificationSummary}.joined(separator: ", "))
        return msgs.filter {$0 != ""}.joined(separator: "; ")
    }
    
    var notificationId: KeyPath<Constants.Identifiers.Notifications, String>? { \.reprPlanUpdateNotification }
    
    var notificationTitle: String { "repr_plan_update" }
    
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
