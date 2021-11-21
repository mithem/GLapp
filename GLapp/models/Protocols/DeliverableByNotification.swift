//
//  DeliverableByNotification.swift
//  DeliverableByNotification
//
//  Created by Miguel Themann on 19.10.21.
//

import UserNotifications

protocol DeliverableByNotification {
    var id: String? { get }
    var notificationId: KeyPath<Constants.Identifiers.Notifications, String>? { get }
    var notificationTitle: String { get }
    var notificationSummary: String { get }
    
    var interruptionLevel: NotificationManager.InterruptionLevel { get }
    var relevance: Double { get }
    var sound: UNNotificationSound? { get }
}

extension DeliverableByNotification {
    var id: String? { nil }
    var notificationId: KeyPath<Constants.Identifiers.Notifications, String>? { nil }
    var sound: UNNotificationSound? {
        if relevance < 2 { return nil }
        return .default
    }
}
