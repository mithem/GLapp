//
//  ClassTest+DeliverableByNotification.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension ClassTest: DeliverableByNotification {
    var interruptionLevel: NotificationManager.InterruptionLevel { .active }
    
    var relevance: Double { .nan } // why force time-sensitivity?
    
    var title: String { subject.title }
    
    var notificationTitle: String { title }
    
    var notificationSummary: String {
        var daysBeforeClassTest = UserDefaults.standard.integer(for: \.classTestReminderNotificationBeforeDays)
        if daysBeforeClassTest == 0 { // no previous initialization e.g. by SettingsView
            daysBeforeClassTest = Constants.defaultClassTestReminderNotificationsBeforeDays
        }
        let deltaComponents = DateComponents(day: daysBeforeClassTest)
        return "\(alias) \(GLDateFormatter.numericRelativeDateTimeFormatter.localizedString(from: deltaComponents))"
    }
}
