//
//  SettingsStore.swift
//  GLapp
//
//  Created by Miguel Themann on 14.01.22.
//

import Foundation
import UIKit

class SettingsStore: ObservableObject {
    @Published var backgroundReprPlanCheckTimeInterval = SettingsValueStrideable(key: \.backgroundReprPlanCheckTimeInterval, defaultValue: 600.0, range: 600...3600, step: 60)
    @Published var backgroundReprPlanNotifications = SettingsValueWithFunctionality(key: \.backgroundReprPlanNotificationsEnabled, functionality: \.backgroundReprPlanNotifications, defaultValue: false)
    @Published var reprPlanNotificationsHighRelevanceTimeInterval = SettingsValueStrideable(key: \.reprPlanNotificationsHighRelevanceTimeInterval, defaultValue: 4.0 * 3600, range: 3600...(24 * 3600), step: 3600)
    @Published var reprPlanNotificationsEntireReprPlan = SettingsValue(key: \.reprPlanNotificationsEntireReprPlan, defaultValue: false)
    @Published var dontSaveReprPlanUpdateTimestampWhenViewingReprPlan = SettingsValue(key: \.dontSaveReprPlanUpdateTimestampWhenViewingReprPlan, defaultValue: false) { dontSave in
        if dontSave ?? true {
            removeLastReprPlanUpdateTimestamp()
        }
    }
    @Published var classTestCalendarEvents = SettingsValueWithFunctionality(key: \.classTestCalendarEvents, functionality: \.classTestCalendarEvents, defaultValue: false)
    @Published var classTestReminders = SettingsValueWithFunctionality(key: \.automaticallyRemindBeforeClassTests, functionality: \.classTestReminders, defaultValue: false)
    @Published var classTestRemindersRemindBeforeDays = SettingsValueStrideable(key: \.classTestReminderNotificationBeforeDays, defaultValue: 3, range: 1...31, step: 1)
    @Published var classTestRemindersTimeMode = SettingsValue(key: \.classTestReminderTimeMode, defaultValue: ClassTestReminderTimeMode.atClassTestTime)
    @Published var classTestRemindersManualTime = SettingsValue(key: \.classTestReminderManualTime, defaultValue: Date.today(at: .init(hour: 9)))
    @Published var coloredInlineSubjects = SettingsValueWithFunctionality(key: \.coloredInlineSubjects, functionality: \.coloredInlineSubjects, defaultValue: true)
    @Published var spotlightIntegration = SettingsValueWithFunctionality(key: \.disableSpotlightIntegration, functionality: \.spotlightIntegration, defaultValue: false)
    @Published var requireAuthentication = SettingsValueWithFunctionality(key: \.requireAuthentication, functionality: \.requireAuthentication, defaultValue: false)
    @Published var demoMode = SettingsValueWithFunctionality(key: \.demoMode, functionality: \.demoMode, defaultValue: false)
    @Published var didUnlockInCurrentSession = SettingsValue(key: \.didUnlockInCurrentSession, defaultValue: false)
    @Published var isUnlocking = SettingsValue(key: \.isUnlocking, defaultValue: false)
    @Published var launchCount = SettingsValueStrideable(key: \.launchCount, defaultValue: 0, range: 0...Int(truncating: NSDecimalNumber(decimal: pow(10, 20))), step: 1)
    
    func reset(withHapticFeedback: Bool = false) {
        let generator: UINotificationFeedbackGenerator? = withHapticFeedback ? .init() : nil
        generator?.prepare()
        backgroundReprPlanCheckTimeInterval.resetToDefault()
        backgroundReprPlanNotifications.resetToDefault()
        reprPlanNotificationsHighRelevanceTimeInterval.resetToDefault()
        reprPlanNotificationsEntireReprPlan.resetToDefault()
        dontSaveReprPlanUpdateTimestampWhenViewingReprPlan.resetToDefault()
        classTestCalendarEvents.resetToDefault()
        classTestReminders.resetToDefault()
        classTestRemindersRemindBeforeDays.resetToDefault()
        classTestRemindersTimeMode.resetToDefault()
        classTestRemindersManualTime.resetToDefault()
        coloredInlineSubjects.resetToDefault()
        spotlightIntegration.resetToDefault()
        requireAuthentication.resetToDefault()
        demoMode.resetToDefault()
        didUnlockInCurrentSession.resetToDefault()
        isUnlocking.resetToDefault()
        launchCount.resetToDefault()
        generator?.notificationOccurred(.success)
    }
    
    func selfRepair() {
        backgroundReprPlanCheckTimeInterval.selfRepair()
        reprPlanNotificationsHighRelevanceTimeInterval.selfRepair()
        classTestRemindersRemindBeforeDays.selfRepair()
        launchCount.selfRepair()
    }
}
