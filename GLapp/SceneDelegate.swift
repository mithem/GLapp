//
//  SceneDelegate.swift
//  GLapp
//
//  Created by Miguel Themann on 13.11.21.
//

import UIKit
import Intents

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        for userActivity in connectionOptions.userActivities {
            handleUserActivity(userActivity)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        handleUserActivity(userActivity)
    }
    
    func handleUserActivity(_ activity: NSUserActivity) {
        var intent: IntentToHandle? = nil
        if let interaction = activity.interaction {
            if let inte = IntentToHandle(intent: interaction.intent) {
                intent = inte
            }
        } else if let userInfo = activity.userInfo {
            guard let identifier = userInfo["kCSSearchableItemActivityIdentifier"] as? String else { return }
            intent = IntentToHandle(CSSearchableItemActivityIdentifier: identifier)
        }
        intent?.save()
    }
}
