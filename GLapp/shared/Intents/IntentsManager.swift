//
//  IntentsManager.swift
//  GLapp
//
//  Created by Miguel Themann on 13.11.21.
//

import Intents

class IntentsManager {
    static func donateShortcutSuggestions() {
        guard let reprPlanShortcut = INShortcut(intent: ShowRepresentativePlanIntent()) else { fatalError("Couldn't create INShortcut from ShowRepresentativePlanIntent") }
        INVoiceShortcutCenter.shared.setShortcutSuggestions([reprPlanShortcut])
    }
    
    static func reset() {
        INVoiceShortcutCenter.shared.setShortcutSuggestions([])
    }
}
