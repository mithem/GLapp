//
//  NotificationManager.swift
//  NotificationManager
//
//  Created by Miguel Themann on 14.10.21.
//

import UserNotifications
import Combine

class NotificationManager {
    
    static func removeAllScheduled() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    static func removeAllDelivered() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
    }
    
    static func deliverNotification(title: String, body: String) {
        requestNotificationAuthorization()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Constants.checkReprPlanInBackgroundTimeIntervalTillNotificationScheduled, repeats: false)
        let request = UNNotificationRequest(identifier: Constants.Identifiers.newReprPlanNotification, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    static func checkRepresentativePlanAndDeliverNotification() {
        // yes, this doesn't yet use the &timestamp parameter and therefore isn't that useful for observing change
        let manager = MockDataManager()
        manager.loadRepresentativePlan()
        _ = manager.$representativePlan.sink { reprPlan in
            //if !(reprPlan?.isEmpty ?? true) {
            deliverNotification(title: NSLocalizedString("repr_plan_update", comment: "repr_plan_update"), body: reprPlan?.notes.lazy.joined(separator: ", ") ?? NSLocalizedString("no_repr_plan", comment: "no_repr_plan"))
            //}
        }
    }
    
    static func requestNotificationAuthorization() {
        checkNotificationsEnabled() { enabled in
            if enabled {
                return
            }
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .criticalAlert, .provisional, .sound]) { success, error in
                if !success {
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
    }
    
    static func checkNotificationsEnabled(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let status = settings.authorizationStatus
            if [.authorized, .ephemeral, .provisional].contains(status) { // the Swift compiler (and accompanying tools) at it's best!
                completion(true)
                return
            }
            completion(false)
            return
        }
    }
}
