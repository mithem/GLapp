//
//  UserDefaultsKeys.swift
//  UserDefaultsKeys
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

struct UserDefaultsKeys {
    let mobileKey = "mobileKey"
    let userIsTeacher = "userIsTeacher"
    let subjects = "subjects"
    let lastTabView = "lastTabView"
    let lastReprPlanUpdateTimestamp = "lastReprPlanUpdateTimestamp"
    let classTestReminderNotificationBeforeDays = "classTestReminderNotificationBeforeDays"
    let automaticallyRemindBeforeClassTests = "automaticallyRemindBeforeClassTests"
    let backgroundReprPlanNotificationsEnabled = "backgroundReprPlanNotificationsEnabled"
    let demoMode = "demoMode"
    let launchCount = "launchCount"
    let lastLaunchedVersion = "lastLaunchedVersion"
    let coloredInlineSubjects = "coloredInlineSubjects"
    let classTestCalendarEvents = "classTestCalendarEvents"
    let calendarIdentifier = "calendarIdentifier"
    /// The TimeInterval, as the distance to the repr lesson from the current time, at which the lesson is considered to have a high relevance (e.g. to send a time-sensitive notification)
    let reprPlanNotificationsHighRelevanceTimeInterval = "reprPlanNotificationsHighRelevanceTimeInterval"
    let reprPlanNotificationsEntireReprPlan = "reprPlanNotificationsEntireReprPlan"
    let intentToHandle = "intentToHandle"
    /// Don't save update timestamp, so repr plan notifications will be delivered even after viewing the plan in-app
    let dontSaveReprPlanUpdateTimestampWhenViewingReprPlan = "dontSaveReprPlanUpdateTimestampWhenViewingReprPlan"
    let disableSpotlightIntegration = "disableSpotlightIntegration"
    let classTestPlanNotSupported = "classTestPlanNotSupported"
    let didShowFunctionalityCheck = "didShowFunctionalityCheck"
    let classTestReminderTimeMode = "classTestReminderTimeMode"
    let classTestReminderManualTime = "classTestReminderManualTime"
}
