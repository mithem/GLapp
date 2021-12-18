//
//  IntentHandler.swift
//  GLapp
//
//  Created by Miguel Themann on 13.11.21.
//

import UIKit
import Intents

struct IntentHandler {
    static func handle(_ intent: IntentToHandle) {
        UserDefaults.standard.set(intent.rawValue, for: \.intentToHandle)
    }
}
