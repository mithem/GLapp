//
//  IntentsManager.swift
//  GLapp
//
//  Created by Miguel Themann on 13.11.21.
//

import Intents
import CoreSpotlight
import UIKit

/// Handles intents and the indexing of items for Spotlight
class IntentsManager {
    static func reset() {
        INVoiceShortcutCenter.shared.setShortcutSuggestions([])
        CSSearchableIndex.default().deleteAllSearchableItems(completionHandler: nil)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.intentToHandle)
    }
    
    static func index<ContentType>(items: [ContentType]) where ContentType: CSIndexable {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return } // iPadOS UI doesn't support that
        let index = CSSearchableIndex.default()
        index.deleteAllSearchableItems { error in
            if let error = error {
                print(error)
            }
            let searchItems = items.map {$0.makeSearchableItem()}
            index.indexSearchableItems(searchItems) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
}
