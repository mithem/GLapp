//
//  NotificationManager.swift
//  NotificationManager
//
//  Created by Miguel Themann on 14.10.21.
//

import UserNotifications
import Combine
import BackgroundTasks

final class NotificationManager {
    
    private var notificationIds: [String]
    
    class var `default`: NotificationManager { NotificationManager() }
    
    var notificationIdsFSURL: URL? {
        let appDir = try? FileManager.default.url(for: .applicationDirectory, in: .localDomainMask, appropriateFor: nil, create: false)
        let dir = URL(string: Constants.Identifiers.appId, relativeTo: appDir)
        return URL(string: "notificationIds.json", relativeTo: dir)
    }
    
    func deliverNotification(title: String, body: String, timeSensitive: Bool = false, sound: UNNotificationSound? = nil, identifier: KeyPath<Constants.Identifiers.Notifications, String> = \.testNotification) {
        requestNotificationAuthorization()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        if #available(iOS 15, *) {
            content.interruptionLevel = timeSensitive ? .timeSensitive : .active
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Constants.checkReprPlanInBackgroundTimeIntervalTillNotificationScheduled, repeats: false)
        let timestamp: Int
        if #available(iOS 15, *) {
            timestamp = Int(Date.now.timeIntervalSince1970)
        } else {
            timestamp = Int(Date(timeIntervalSinceNow: 0).timeIntervalSince1970)
        }
        let id = Constants.Identifiers.Notifications()[keyPath: identifier] + String(timestamp)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            } else {
                self.notificationIds.append(id)
            }
        }
    }
    
    func checkRepresentativePlanAndDeliverNotification(task: BGTask) {
        let manager = DataManager()
        manager.getRepresenativePlanUpdate { result in
            switch result {
            case .success(let plan):
                if !plan.isEmpty {
                    self.deliverNotification(title: NSLocalizedString("repr_plan_update"), body: plan.summary)
                }
                task.setTaskCompleted(success: true)
            case .failure(let error):
                print(error)
                task.setTaskCompleted(success: false)
            }
        }
    }
    
    func requestNotificationAuthorization() {
        checkNotificationsEnabled() { enabled in
            if enabled {
                return
            }
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .provisional, .sound]) { success, error in
                if !success {
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
    }
    
    func checkNotificationsEnabled(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let status = settings.authorizationStatus
            if [.authorized, .ephemeral, .provisional].contains(status) { // the Swift compiler (and accompanying tools) at it's best!
                completion(true)
                return
            }
            if status == .notDetermined {
                self.requestNotificationAuthorization()
                self.checkNotificationsEnabled(completion: completion)
            }
            completion(false)
            return
        }
    }
    
    func scheduleClassTestReminder(for classTest: ClassTest) {
        let timeInterval = classTest.classTestDate.timeIntervalSinceNow - (Double(UserDefaults.standard.integer(forKey: UserDefaultsKeys.classTestReminderNotificationBeforeDays) * 24 * 60) * 60)
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("upcoming_class_test")
        content.body = "\(classTest.alias) \(GLDateFormatter.relativeDateTimeFormatter.localizedString(fromTimeInterval: timeInterval))"
        content.sound = .default
        if #available(iOS 15, *) {
            content.interruptionLevel = .passive
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let id = Constants.Identifiers.Notifications.classTestNotification + GLDateFormatter.formatter.string(from: classTest.classTestDate)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            } else {
                self.notificationIds.append(id)
            }
        }
    }
    
    func scheduleClassTestsReminders(for classTests: [ClassTest]) {
        for classTest in classTests {
            scheduleClassTestReminder(for: classTest)
        }
    }
    
    func saveNotificationIds() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(notificationIds) else { return }
        guard let url = notificationIdsFSURL else { return }
        try? data.write(to: url)
    }
    
    func loadNotificationIds() {
        guard let url = notificationIdsFSURL else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        let decoder = JSONDecoder()
        guard let ids = try? decoder.decode([String].self, from: data) else { return }
        notificationIds = ids
    }
    
    /// Remove scheduled notifications.
    /// - Parameter ids: notification ids to remove
    func removeScheduled(_ ids: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        notificationIds.removeAll(where: {ids.contains($0)})
    }
    
    /// Remove all scheduled notifications.
    func removeAllScheduled() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        notificationIds.removeAll()
    }
    
    /// Remove delivered notifications.
    /// - Parameter ids: notification ids to remove
    func removeDelivered(_ ids: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
        notificationIds.removeAll(where: {ids.contains($0)})
    }
    
    /// Remove all delivered notifications.
    func removeAllDelivered() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        notificationIds.removeAll()
    }
    
    func removeScheduledClassTestReminders() {
        var toRemove = [String]()
        for notificationId in notificationIds {
            if notificationId.starts(with: Constants.Identifiers.Notifications.classTestNotification) {
                toRemove.append(notificationId)
            }
        }
        removeScheduled(toRemove)
    }
    
    /// Remove all notifications that are delivered and appropriate for removal (e.g. class test reminders only after the class test)
    func removeAllDeliveredAndAppropriate() {
        // TODO: Implement
        removeAllDelivered()
    }
    
    func reset() {
        removeAllDelivered()
        removeAllScheduled()
        guard let url = notificationIdsFSURL else { return }
        try? FileManager.default.removeItem(at: url)
    }
    
    init() {
        notificationIds = []
        loadNotificationIds()
    }
    
    deinit {
        saveNotificationIds()
    }
}
