//
//  UserDefaultsKeys.swift
//  UserDefaultsKeys
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

struct UserDefaultsKeys {
    static let mobileKey = "mobileKey"
    static let userIsTeacher = "userIsTeacher"
    static let subjects = "subjects"
    static let lastTabView = "lastTabView"
    static let lastReprPlanUpdateTimestamp = "lastReprPlanUpdateTimestamp"
    static let classTestReminderNotificationBeforeDays = "classTestReminderNotificationBeforeDays"
    static let automaticallyRemindBeforeClassTests = "automaticallyRemindBeforeClassTests"
    static let backgroundReprPlanNotificationsEnabled = "backgroundReprPlanNotificationsEnabled"
    static let demoMode = "demoMode"
    static let launchCount = "launchCount"
    static let lastLaunchedVersion = "lastLaunchedVersion"
    static let coloredInlineSubjects = "coloredInlineSubjects"
    static let classTestCalendarEvents = "classTestCalendarEvents"
    static let calendarIdentifier = "calendarIdentifier"
    /// The TimeInterval, as the distance to the repr lesson from the current time, at which the lesson is considered to have a high relevance (e.g. to send a time-sensitive notification)
    static let reprPlanNotificationsHighRelevanceTimeInterval = "reprPlanNotificationsHighRelevanceTimeInterval"
    static let reprPlanNotificationsEntireReprPlan = "reprPlanNotificationsEntireReprPlan"
    static let intentToHandle = "intentToHandle"
    /// Don't save update timestamp, so repr plan notifications will be delivered even after viewing the plan in-app
    static let dontSaveReprPlanUpdateTimestampWhenViewingReprPlan = "dontSaveReprPlanUpdateTimestampWhenViewingReprPlan"
    static let disableSpotlightIntegration = "disableSpotlightIntegration"
    static let classTestPlanNotSupported = "classTestPlanNotSupported"
}
