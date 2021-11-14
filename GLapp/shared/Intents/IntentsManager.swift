//
//  IntentsManager.swift
//  GLapp
//
//  Created by Miguel Themann on 13.11.21.
//

import Intents

class IntentsManager {
    static func reset() {
        INVoiceShortcutCenter.shared.setShortcutSuggestions([])
    }
}
