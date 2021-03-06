//
//  Constants.swift
//  Constants
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation
import SwiftUI
import Semver

struct Constants {
    static let apiHostname = "https://mobil.gymnasium-lohmar.org"
    static let internerBereichReprPlanURL = URL(string: "https://mobil.gymnasium-lohmar.org/?show=vplan")!
    static let timeoutInterval: TimeInterval = 15
    static let mailToURL = URL(string: "mailto:miguel.themann@gmail.com")!
    static let functionalityReloadInterval: TimeInterval = 10
    static let lessonStartDateComponents = getLessonStartDateComponents()
    static let lessonEndDateComponents = getLessonEndDateComponents()
    static let timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated: TimeInterval = 4
    static let appDataDir = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(Constants.Identifiers.appId)
    /// When to add the first extra component (hours, at 1/3rd this interval also minutes) to increase (relative) precision
    static let relativeDateTimeFormatterTimeIntervalToIncreasePrecision: TimeInterval = 60 * 60 * 24 * 3
    static let appStoreWriteReviewURL = URL(string: "https://apps.apple.com/\(Locale.current.regionCode ?? "de")/app/glapp-gymnasium-lohmar-app/id1591743755?action=write-review")!
    
    struct ReviewRequests {
        static let minimumTimeIntervalBetweenRequests: TimeInterval = 14 * 24 * 60 * 60 // 2 weeks
        static let minimumLaunchCount = 10
        static let minimumTimeIntervalSinceUpdate: TimeInterval = 2 * 24 * 60 * 60 // 2 days
    }

    struct Identifiers {
        static let appId = "com.mithem.GLapp"
        static let backgroundCheckRepresentativePlan = appId + ".backgroundCheckRepresentativePlan"
        
        struct Notifications {
            static let reprPlanUpdateNotification = appId + ".reprPlanUpdateNotification"
            static let testNotification = appId + ".testNotification"
            static let classTestNotification = appId + ".classTestNotification"
            // https://forums.swift.org/t/key-path-cannot-refer-to-static-member/28055
            var reprPlanUpdateNotification: String { Self.reprPlanUpdateNotification }
            var testNotification: String { Self.testNotification }
            var classTestNotification: String { Self.classTestNotification }
        }
        
        struct Functionalities {
            static let notifications = Functionality.Identifier("notifications")
            static let timeSensitiveNotifications = Functionality.Identifier("time_sensitive_notifications")
            static let backgroundRefresh = Functionality.Identifier("background_refresh")
            static let classTestReminders = Functionality.Identifier("class_test_reminders")
            static let backgroundReprPlanNotifications = Functionality.Identifier("background_repr_plan_notifications")
            static let demoMode = Functionality.Identifier("demo_mode")
            static let coloredInlineSubjects = Functionality.Identifier("colored_inline_subjects")
            static let classTestPlan = Functionality.Identifier("class_test_plan")
            static let calendarAccess = Functionality.Identifier("calendar_access")
            static let classTestCalendarEvents = Functionality.Identifier("class_test_calendar_events")
            static let spotlightIntegration = Functionality.Identifier("spotlight_integration")
            static let requireAuthentication = Functionality.Identifier("authentication")
        }
    }
    
    struct FeedbackGenerator {
        static func didChangeStepperValue() {
            //UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.5)
            UISelectionFeedbackGenerator().selectionChanged()
        }
        static func didChangeSegmentedControlValue() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred(intensity: 0.5)
        }
    }
    
    private static func getLessonStartDateComponents() -> [Int: DateComponents] {
        var components: [Int: DateComponents] = [
            1: .init(hour: 7, minute: 45),
            2: .init(hour: 8,  minute: 35),
            3: .init(hour: 9, minute: 25),
            4: .init(hour: 10, minute: 30),
            5: .init(hour: 11, minute: 20),
            6: .init(hour: 12, minute: 20),
            7: .init(hour: 13, minute: 10),
            8: .init(hour: 14, minute: 10),
            9: .init(hour: 14, minute: 55),
        ]
        for i in 10...19 { // till midnight
            let prevComponents = components[i - 1]!
            let calendar = Calendar.current
            let newComponents = calendar.dateComponents([.hour, .minute], from: calendar.date(from: prevComponents + .init(minute: 50))!)
            components[i] = newComponents
        }
        return components
    }
    
    private static func getLessonEndDateComponents() -> [Int: DateComponents] {
        return lessonStartDateComponents.mapValues({$0 + .init(minute: 45)}) // overflow will result in hour/day/etc. to increase (though anything else than an overflowing hour shouldn't happen????)
    }
}
