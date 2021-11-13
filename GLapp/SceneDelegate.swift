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
        guard let intent = IntentToHandle(intent: activity.interaction?.intent) else { return }
        intent.save()
    }
}
