//
//  AppManager.swift
//  AppManager
//
//  Created by Miguel Themann on 20.10.21.
//

import UIKit
import Combine

/// Responsible for app-related stuff like whether the user enabled a certain feature and version information.
final class AppManager: ObservableObject {
    @Published var notifications: FNotifications
    @Published var backgroundRefresh: FBackgroundRefresh
    @Published var backgroundReprPlanNotifications: FBackgroundReprPlanNotifications
    @Published var classTestReminders: FClassTestReminders
    @Published var demoMode: FDemoMode
    @Published var coloredInlineSubjects: FColoredInlineSubjects
    @Published var classTestPlan: FClassTestPlan
    @Published var calendarAccess: FCalendarAccess
    @Published var classTestCalendarEvents: FClassTestCalendarEvents
    @Published var spotlightIntegration: FSpotlightIntegration
    @Published var userAttentionMayBeRequired: Bool
    
    var userExperienceRelevantFunctionalities: [Functionality] { // no computed property so it's redrawn every time FunctionalityCheckView refreshes
        var types = [Functionality.FunctionalityType.notifications, .backgroundRefresh, .backgroundReprPlanNotifications, .spotlightIntegration]
        if classTestPlan.isEnabled.unwrapped {
            types.append(contentsOf: [.calendarAccess, .classTestReminders, .classTestCalendarEvents])
        }
        return types.map {functionality(of: $0)}
    }
    
    var hasLoadedAllRelevantFunctionalityStates: Bool {
        for functionality in userExperienceRelevantFunctionalities {
            if functionality.isEnabled == .unknown { return false }
        }
        return true
    }
    
    init() {
        notifications = .init()
        backgroundRefresh = .init()
        backgroundReprPlanNotifications = .init()
        classTestReminders = .init()
        demoMode = .init()
        coloredInlineSubjects = .init()
        classTestPlan = .init()
        calendarAccess = .init()
        classTestCalendarEvents = .init()
        spotlightIntegration = .init()
        userAttentionMayBeRequired = false
    }
    
    /// Reload whether user attention may be required. Must be called from the main thread.
    func reloadUserAttentionMayBeRequired() {
        var required = false
        for functionality in userExperienceRelevantFunctionalities {
            if functionality.mayRequireUsersAttention == .yes {
                required = true
            }
        }
        self.userAttentionMayBeRequired = required
    }
    
    /// Reload functionality type. Must be called from the main thread.
    func reload(_ type: Functionality.FunctionalityType, with dataManager: DataManager) {
        try? functionality(of: type).reload(with: self, dataManager: dataManager)
        reloadUserAttentionMayBeRequired()
    }
    
    func reload(with dataManager: DataManager) {
        DispatchQueue.main.async {
            self.reload(.notifications, with: dataManager)
            self.reload(.backgroundRefresh, with: dataManager)
            self.reload(.backgroundReprPlanNotifications, with: dataManager)
            self.reload(.classTestReminders, with: dataManager)
            self.reload(.demoMode, with: dataManager)
            self.reload(.coloredInlineSubjects, with: dataManager)
            self.reload(.classTestPlan, with: dataManager)
            self.reload(.calendarAccess, with: dataManager)
            self.reload(.classTestCalendarEvents, with: dataManager)
            self.reload(.spotlightIntegration, with: dataManager)
        }
    }
    
    func functionality(of type: Functionality.FunctionalityType) -> Functionality {
        switch type {
        case .notifications:
            return notifications
        case .backgroundRefresh:
            return backgroundRefresh
        case .backgroundReprPlanNotifications:
            return backgroundReprPlanNotifications
        case .classTestReminders:
            return classTestReminders
        case .demoMode:
            return demoMode
        case .coloredInlineSubjects:
            return coloredInlineSubjects
        case .classTestPlan:
            return classTestPlan
        case .calendarAccess:
            return calendarAccess
        case .classTestCalendarEvents:
            return classTestCalendarEvents
        case .spotlightIntegration:
            return spotlightIntegration
        }
    }
    
    func hasDisabledFunctionalities() -> (`optional`: Bool, critical: Bool) {
        var result = (optional: false, critical: false)
        for functionality in userExperienceRelevantFunctionalities {
            if functionality.isEnabled == .no {
                switch functionality.role {
                case .optional:
                    result.optional = true
                case .critical:
                    result.critical = true
                }
            }
        }
        return result
    }
}
