//
//  IntentToHandle.swift
//  GLapp
//
//  Created by Miguel Themann on 13.11.21.
//

import Foundation
import Intents

enum IntentToHandle: String {
    case showTimetable = "ShowTimetableIntent"
    case showClassTestPlan = "ShowClassTestPlanIntent"
    case showRepresentativePlan = "ShowRepresentativePlanIntent"
    
    init?(intent: INIntent?) {
        guard let intent = intent else { return nil }
        if intent is ShowTimetableIntent {
            self = .showTimetable
        } else if intent is ShowClassTestPlanIntent {
            self = .showClassTestPlan
        } else if intent is ShowRepresentativePlanIntent {
            self = .showRepresentativePlan
        } else {
            return nil
        }
    }
    
    func save() {
        UserDefaults.standard.set(rawValue, forKey: UserDefaultsKeys.intentToHandle)
    }
    
    func donate() {
        let activity = NSUserActivity(activityType: self.rawValue)
        switch self {
        case .showTimetable:
            activity.title = NSLocalizedString("timetable")
        case .showClassTestPlan:
            activity.title = NSLocalizedString("class_test_plan")
        case .showRepresentativePlan:
            activity.title = NSLocalizedString("representative_plan")
        }
        activity.suggestedInvocationPhrase = NSLocalizedString("suggestion_" + rawValue)
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.shortcutAvailability = .sleepWrapUpYourDay
        activity.becomeCurrent()
    }
}
