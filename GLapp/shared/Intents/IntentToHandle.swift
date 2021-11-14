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
    
    static var intentMap: [String: INIntent.Type] = [
        "ShowTimetableIntent": ShowTimetableIntent.self,
        "ShowClassTestPlanIntent": ShowClassTestPlanIntent.self,
        "ShowRepresentativePlanIntent": ShowRepresentativePlanIntent.self
    ]
    
    func save() {
        UserDefaults.standard.set(rawValue, forKey: UserDefaultsKeys.intentToHandle)
    }
    
    func donate() {
        guard let intentType = Self.intentMap[rawValue] else { fatalError("intentMap incomplete") }
        let intent = intentType.init()
        intent.suggestedInvocationPhrase = NSLocalizedString("suggestion_" + rawValue)
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate()
    }
}
