//
//  IntentToHandle.swift
//  GLapp
//
//  Created by Miguel Themann on 13.11.21.
//

import Foundation
import Intents
import UIKit

enum IntentToHandle {
    case showTimetable
    case showClassTestPlan
    case showRepresentativePlan
    case unknown(identifier: String)
    
    var rawValue: String {
        switch self {
        case .showTimetable:
            return "ShowTimetableIntent"
        case .showClassTestPlan:
            return "ShowClassTestPlanIntent"
        case .showRepresentativePlan:
            return "ShowRepresentativePlanIntent"
        case .unknown(identifier: let id):
            return id
        }
    }
    
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
    
    init?(rawValue: String?) {
        switch rawValue {
        case "ShowTimetableIntent":
            self = .showTimetable
        case "ShowClassTestPlanIntent":
            self = .showClassTestPlan
        case "ShowRepresentativePlanIntent":
            self = .showRepresentativePlan
        case "", .none:
            return nil
        default:
            self = .unknown(identifier: rawValue!)
        }
    }
    
    init(CSSearchableItemActivityIdentifier id: String) {
        self = .unknown(identifier: id)
    }
    
    static var intentMap: [String: INIntent.Type] = [
        "ShowTimetableIntent": ShowTimetableIntent.self,
        "ShowClassTestPlanIntent": ShowClassTestPlanIntent.self,
        "ShowRepresentativePlanIntent": ShowRepresentativePlanIntent.self
    ]
    
    static var selfMap: [String: Self] = [
        "ShowTimetableIntent": .showTimetable,
        "ShowClassTestPlanIntent": .showClassTestPlan,
        "ShowRepresentativePlanIntent": .showRepresentativePlan
    ]
    
    func save() {
        UserDefaults.standard.set(rawValue, forKey: UserDefaultsKeys.intentToHandle)
    }
    
    func donate() {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return } // iPadOS UI doesn't allow for opening correct views
        guard let intentType = Self.intentMap[rawValue] else { fatalError("intentMap incomplete") }
        let intent = intentType.init()
        intent.suggestedInvocationPhrase = NSLocalizedString("suggestion_" + rawValue)
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate()
    }
}
