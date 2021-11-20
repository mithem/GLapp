//
//  AppDelegate.swift
//  AppDelegate
//
//  Created by Miguel Themann on 14.10.21.
//

import UIKit
import Intents

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        BackgroundTaskManager.registerTasks()
        BackgroundTaskManager.scheduleRepresentativeCheckTask()
        
        UNUserNotificationCenter.current().delegate = self
        
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.launchCount)
        UserDefaults.standard.set(count + 1, forKey: UserDefaultsKeys.launchCount)
        
        let lastVersion = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastLaunchedVersion)
        UserDefaults.standard.set(Constants.appVersion, forKey: UserDefaultsKeys.lastLaunchedVersion)
        if lastVersion != Constants.appVersion {
            resetOnboarding()
        }
        
        try? createAppDataDirIfAppropriate()
        
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}
