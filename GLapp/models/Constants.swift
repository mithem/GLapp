//
//  Constants.swift
//  Constants
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation
import SwiftUI

struct Constants {
    static let apiHostname = "https://mobil.gymnasium-lohmar.org"
    static let timeoutInterval: TimeInterval = 15
    static let checkReprPlanInBackgroundAfterMin: TimeInterval = 10 // 10 * 60
    static let checkReprPlanInBackgroundTimeIntervalTillNotificationScheduled: TimeInterval = 10
    static let weekdayStringIDMap = [
        "Montag": 0,
        "Dienstag": 1,
        "Mittwoch": 2,
        "Donnerstag": 3,
        "Freitag": 4,
        "Samstag": 5,
        "Sonntag": 6
    ]
    static let weekdayIDStringMap = getWeekdayIDStringMap()
    static let defaultClassTestReminderNotificationsBeforeDays = 3
    static let mailToURL = URL(string: "mailto:miguel.themann@gmail.com")!
    static let functionalityReloadInterval: TimeInterval = 10
    static let lessonStartDateComponents: [Int: DateComponents] = [
        1: .init(hour: 7, minute: 45),
        2: .init(hour: 8,  minute: 35),
        3: .init(hour: 9, minute: 25),
        4: .init(hour: 10, minute: 30),
        5: .init(hour: 11, minute: 20),
        6: .init(hour: 12, minute: 20),
        7: .init(hour: 13, minute: 10),
        8: .init(hour: 14, minute: 10),
        9: .init(hour: 14, minute: 55)
    ]
    static let lessonEndDateComponents = getLessonEndDateComponents()
    
    struct Identifiers {
        static let appId = "com.mithem.GLapp"
        static let backgroundCheckRepresentativePlan = appId + ".backgroundCheckRepresentativePlan"
        struct Notifications {
            static let newReprPlanNotification = appId + ".newRepresentativePlanNotification"
            static let testNotification = appId + ".testNotification"
            static let classTestNotification = appId + ".classTestNotification"
            // https://forums.swift.org/t/key-path-cannot-refer-to-static-member/28055
            var newReprPlanNotification: String { Self.newReprPlanNotification }
            var testNotification: String { Self.testNotification }
            var classTestNotification: String { Self.classTestNotification }
        }
        
        struct Functionalities {
            static let notifications = "notifications"
            static let backgroundRefresh = "background_refresh"
            static let autoRemindBeforeClassTests = "class_test_reminders"
            static let backgroundReprPlanNotifications = "background_repr_plan_notifications"
            static let demoMode = "demo_mode"
        }
    }
    
    private static func getWeekdayIDStringMap() -> Dictionary<Int, String> {
        var map = Dictionary<Int, String>()
        for string in weekdayStringIDMap.keys {
            guard let id = weekdayStringIDMap[string] else { continue }
            map[id] = NSLocalizedString(string)
        }
        return map
    }
    
    private static func getLessonEndDateComponents() -> [Int: DateComponents] {
        return lessonStartDateComponents.mapValues({$0 + .init(minute: 45)}) // overflow will result in hour/day/etc. to increase (though anything else than an overflowing hour shouldn't happen😅)
    }
}
