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
        let timestamp = Int(Date.rightNow.timeIntervalSince1970)
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
        let dataManager = DataManager(appManager: .init())
        dataManager.getRepresenativePlanUpdate { result in
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
    
    func requestNotificationAuthorization(unrestricted: Bool = false) {
        getNotificationStatus() { status in
            if status.validAuthoriatization && !unrestricted {
                return
            }
            var options: UNAuthorizationOptions = [.alert, .sound]
            if !unrestricted {
                options.insert(.provisional)
            }
            UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
                if !success {
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
    }
    
    func getNotificationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let status = settings.authorizationStatus
            if status == .notDetermined {
                self.requestNotificationAuthorization()
                self.getNotificationStatus(completion: completion)
            }
            completion(status)
            return
        }
    }
    
    func scheduleClassTestReminder(for classTest: ClassTest) {
        let classTestDate = classTest.startDate ?? classTest.classTestDate
        let classTestDateComponents = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .hour, .minute], from: classTestDate)
        var daysBeforeClassTest = UserDefaults.standard.integer(forKey: UserDefaultsKeys.classTestReminderNotificationBeforeDays)
        if daysBeforeClassTest == 0 { // no previous initialization e.g. by SettingsView
            daysBeforeClassTest = 3
        }
        var reminderComponents = classTestDateComponents
        reminderComponents.day! -= daysBeforeClassTest
        reminderComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Calendar.current.date(from: reminderComponents)!) // if a classTest is scheduled at the beginning of the month, for example, this is a way for that to actually give valid dateComponents as a trigger, otherwise they would contain negative numbers and not trigger anything
        let reminderDate = Calendar.current.date(from: reminderComponents)!
        guard reminderDate > .rightNow else { return }
        let trigger = UNCalendarNotificationTrigger(dateMatching: reminderComponents, repeats: false)
        
        let deltaComponents = DateComponents(day: daysBeforeClassTest)
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("upcoming_class_test")
        content.body = "\(classTest.alias) \(GLDateFormatter.relativeDateTimeFormatter.localizedString(from: deltaComponents))"
        content.sound = .default
        if #available(iOS 15, *) {
            content.interruptionLevel = .passive
        }
        
        let id = Constants.Identifiers.Notifications.classTestNotification + GLDateFormatter.berlinFormatter.string(from: classTest.classTestDate)
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
    
    func getScheduledClassTestReminders(completion: @escaping (Set<NotificationRequest>) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            var scheduled = Set<NotificationRequest>()
            for request in requests {
                guard let trigger = request.trigger as? UNCalendarNotificationTrigger else { continue }
                guard let date = trigger.nextTriggerDate() else { continue }
                let request = NotificationRequest(triggerDate: date, id: request.identifier, content: request.content.body)
                scheduled.insert(request)
            }
            completion(scheduled)
        }
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
        var toRemove = [String]()
        for id in notificationIds {
            if id.starts(with: Constants.Identifiers.Notifications.classTestNotification) {
                if let date = GLDateFormatter.berlinFormatter.date(from: id.replacingOccurrences(of: Constants.Identifiers.Notifications.classTestNotification, with: "")) {
                    if .rightNow > date {
                        toRemove.append(id)
                    }
                }
            }
        }
        removeDelivered(toRemove)
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
    
    struct NotificationRequest: Identifiable, Hashable, DeliverableByNotification {
        let triggerDate: Date
        let id: String
        let content: String
        
        var summary: String { content }
        
        func cancel() {
            NotificationManager.default.removeScheduled([id])
        }
    }
}
