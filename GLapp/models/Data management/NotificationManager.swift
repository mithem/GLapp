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
    
    private var requests: [NotificationRequest]
    private var delivered: [DeliveredNotification]
    
    class var `default`: NotificationManager { NotificationManager() }
    
    private static let deliveredNotificationsURL = Constants.appDataDir?.appendingPathComponent("deliveredNotifications.json")
    private static let notificationRequestsURL = Constants.appDataDir?.appendingPathComponent("notificationRequests.json")
    
    func deliverNotification(identifier: String, title: String, body: String, sound: UNNotificationSound? = .default, interruptionLevel: InterruptionLevel = .active, in timeInterval: TimeInterval = 1) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            if settings.soundSetting == .enabled {
                content.sound = sound
            }
            if #available(iOS 15, *), settings.timeSensitiveSetting == .enabled {
                content.interruptionLevel = interruptionLevel.unNotificationInterruptionLevel
            }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let id = identifier + String(Date.rightNow.timeIntervalSince1970)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func deliverNotification(identifier: KeyPath<Constants.Identifiers.Notifications, String>, title: String, body: String, sound: UNNotificationSound? = .default, interruptionLevel: InterruptionLevel = .active, in timeInterval: TimeInterval = 1) {
        let id = Constants.Identifiers.Notifications()[keyPath: identifier]
        deliverNotification(identifier: id, title: title, body: body, sound: sound, interruptionLevel: interruptionLevel, in: timeInterval)
    }
    
    func deliverNotification(_ content: DeliverableByNotification, in timeInterval: TimeInterval = 1) {
        let id: String
        if let nId = content.notificationId {
            id = Constants.Identifiers.Notifications()[keyPath: nId]
        } else if let cId = content.id{
            id = cId
        } else {
            return
        }
        deliverNotification(identifier: id, title: NSLocalizedString(content.title), body: NSLocalizedString(content.summary), sound: content.sound, interruptionLevel: content.interruptionLevel, in: timeInterval)
    }
    
    func checkRepresentativePlanAndDeliverNotification(task: BGTask) {
        let lastUpdateTimestamp = UserDefaults.standard.double(forKey: UserDefaultsKeys.lastReprPlanUpdateTimestamp)
        let dataManager = DataManager(appManager: .init())
        dataManager.getRepresenativePlanUpdate { result in
            switch result {
            case .success(let plan):
                if let date = plan.date {
                    if !plan.isEmpty && date.timeIntervalSince1970 > lastUpdateTimestamp {
                        self.getAuthorizationStatus { status in
                            if status == .notDetermined {
                                self.requestNotificationAuthorization(unrestricted: false) { success in
                                    if success {
                                        self.deliverNotification(plan)
                                    }
                                }
                            } else {
                                self.deliverNotification(plan)
                            }
                        }
                    }
                } else if UserDefaults.standard.bool(forKey: UserDefaultsKeys.dontSaveReprPlanUpdateTimestampWhenViewingReprPlan) && UserDefaults.standard.bool(forKey: UserDefaultsKeys.reprPlanNotificationsEntireReprPlan) {
                    self.deliverNotification(plan)
                }
                task.setTaskCompleted(success: true)
            case .failure(let error):
                print(error)
                task.setTaskCompleted(success: false)
            }
        }
    }
    
    func requestNotificationAuthorization(unrestricted: Bool = false, completion: ((Bool) -> Void)? = nil) {
        getAuthorizationStatus() { status in
            if status.functionalityState == .yes && !unrestricted {
                if let completion = completion {
                    completion(true)
                }
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
                if let completion = completion {
                    completion(success)
                }
            }
        }
    }
    
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
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
        
        let id = Constants.Identifiers.Notifications.classTestNotification + classTest.subject.className + classTest.alias + GLDateFormatter.berlinFormatter.string(from: classTest.classTestDate) // can't think of anything more identifiable/safe
        // need to use subject.className and/or alias as there may actually be multiple class tests on one day (not for one person, though (inpersonal ones))
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            } else {
                guard let request = NotificationRequest(from: request) else { return }
                self.requests.append(request)
            }
        }
    }
    
    func scheduleClassTestsReminders(for classTests: [ClassTest]) {
        for classTest in classTests {
            scheduleClassTestReminder(for: classTest)
        }
    }
    
    func getScheduledClassTestReminders(completion: @escaping ([NotificationRequest]) -> Void) {
        getScheduledNotifications { notifications in
            completion(notifications.filter {$0.identifies(with: \.classTestNotification)})
        }
    }
    
    func getScheduledNotifications(completion: @escaping ([NotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            completion(notifications.compactMap { .init(from: $0) })
        }
    }
    
    /// Remove scheduled notifications.
    /// - Parameter ids: notification ids to remove
    func removeScheduled(_ ids: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        requests.removeAll(where: {ids.contains($0.id)})
    }
    
    /// Remove all scheduled notifications.
    func removeAllScheduled() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        requests.removeAll()
    }
    
    /// Remove delivered notifications.
    /// - Parameter ids: notification ids to remove
    func removeDelivered(_ ids: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
        delivered.removeAll(where: {ids.contains($0.id)})
    }
    
    /// Remove all delivered notifications.
    func removeAllDelivered() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        delivered.removeAll()
    }
    
    func removeScheduledClassTestReminders(completion: (() -> Void)? = nil) {
        getScheduledClassTestReminders { requests in
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: requests.map {$0.id})
            if let completion = completion {
                completion()
            }
        }
    }
    
    /// Remove all notifications that are delivered and appropriate for removal (e.g. class test reminders only after the class test)
    func removeAllDeliveredAndAppropriate() {
        var toRemove = [String]()
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            for notification in notifications {
                let request = DeliveredNotification(from: notification)
                if request.identifies(with: \.classTestNotification) {
                    if let date = GLDateFormatter.berlinFormatter.date(from: request.id.replacingOccurrences(of: Constants.Identifiers.Notifications.classTestNotification, with: "")) {
                        if .rightNow > date {
                            toRemove.append(request.id)
                        }
                    }
                } else if request.identifies(with: \.reprPlanUpdateNotification) {
                    toRemove.append(request.id)
                } else if request.identifies(with: \.testNotification) {
                    toRemove.append(request.id)
                }
            }
            self.removeDelivered(toRemove)
        }
    }
    
    private func saveDelivered() throws {
        guard let url = Self.deliveredNotificationsURL else { throw FSError.noURL }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        try encoder.encode(delivered).write(to: url)
    }
    
    private func loadDelivered() throws {
        guard let url = Self.deliveredNotificationsURL else { throw FSError.noURL }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        delivered = try decoder.decode([DeliveredNotification].self, from: try Data(contentsOf: url))
    }
    
    private func saveRequests() throws {
        guard let url = Self.notificationRequestsURL else { throw FSError.noURL }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        try encoder.encode(requests).write(to: url)
    }
    
    private func loadRequests() throws {
        guard let url = Self.notificationRequestsURL else { throw FSError.noURL }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        requests = try decoder.decode([NotificationRequest].self, from: try Data(contentsOf: url))
    }
    
    func reset() {
        removeAllDelivered()
        removeAllScheduled()
    }
    
    init() {
        requests = .init()
        delivered = .init()
        try? loadRequests()
        try? loadDelivered()
    }
    
    deinit {
        try? saveDelivered()
        try? saveRequests()
    }
    
    struct NotificationRequest: Identifiable, Hashable, Codable, DeliverableByNotification {
        let title: String
        let interruptionLevel: NotificationManager.InterruptionLevel
        let relevance: Double
        let triggerDate: Date?
        let id: String
        let content: String
        var summary: String { content }
        
        func cancel() {
            NotificationManager.default.removeScheduled([id])
        }
        
        func identifies(with id: KeyPath<Constants.Identifiers.Notifications, String>) -> Bool {
            self.id.starts(with: Constants.Identifiers.Notifications()[keyPath: id])
        }
        
        init(id idKeyPath: KeyPath<Constants.Identifiers.Notifications, String>, title: String, content: String, triggerDate: Date?, interruptionLevel: NotificationManager.InterruptionLevel, relevance: Double) {
            self.init(id: Constants.Identifiers.Notifications()[keyPath: idKeyPath], title: title, content: content, triggerDate: triggerDate, interruptionLevel: interruptionLevel, relevance: relevance)
        }
        
        init(id: String, title: String, content: String, triggerDate: Date?, interruptionLevel: NotificationManager.InterruptionLevel, relevance: Double) {
            self.id = id
            self.title = title
            self.content = content
            self.triggerDate = triggerDate
            self.interruptionLevel = interruptionLevel
            self.relevance = relevance
        }
        
        init?(from request: UNNotificationRequest) {
            guard let trigger = request.trigger as? UNCalendarNotificationTrigger else { return nil }
            let interruptionLevel: NotificationManager.InterruptionLevel
            let relevance: Double
            if #available(iOS 15, *) {
                interruptionLevel = .init(from: request.content.interruptionLevel) ?? .default
                relevance = request.content.relevanceScore
            } else {
                interruptionLevel = .default
                relevance = 0
            }
            self.init(id: request.identifier, title: request.content.title, content: request.content.body, triggerDate: trigger.nextTriggerDate(), interruptionLevel: interruptionLevel, relevance: relevance)
        }
    }
    
    struct DeliveredNotification: Codable, DeliverableByNotification {
        let id: String
        let title: String
        let content: String
        var relevance: Double
        var interruptionLevel: NotificationManager.InterruptionLevel
        
        var summary: String { content }
        
        func remove() {
            NotificationManager.default.removeDelivered([id])
        }
        
        func identifies(with id: KeyPath<Constants.Identifiers.Notifications, String>) -> Bool {
            self.id.starts(with: Constants.Identifiers.Notifications()[keyPath: id])
        }
        
        init(from notification: UNNotification) {
            id = notification.request.identifier
            title = notification.request.content.title
            content = notification.request.content.body
            if #available(iOS 15, *) {
                relevance = notification.request.content.relevanceScore
                interruptionLevel = .init(from: notification.request.content.interruptionLevel) ?? .default
            } else {
                relevance = 0
                interruptionLevel = .default
            }
        }
    }
    
    enum InterruptionLevel: Comparable, Codable {
        case passive, active, timeSensitive, critical
        
        @available(iOS 15.0, *)
        var unNotificationInterruptionLevel: UNNotificationInterruptionLevel {
            switch self {
            case .passive:
                return .passive
            case .active:
                return .active
            case .timeSensitive:
                return .timeSensitive
            case .critical:
                return .critical
            }
        }
        
        static var `default`: InterruptionLevel { .active }
        
        static func < (_ lhs: InterruptionLevel, _ rhs: InterruptionLevel) -> Bool {
            if lhs == rhs { return false }
            if lhs == .passive {
                if [.active, .timeSensitive, .critical].contains(rhs) { return true }
            }
            if lhs == .active {
                if [.timeSensitive, .critical].contains(rhs) { return true }
            }
            if lhs == .timeSensitive && rhs == .critical { return true }
            return false
        }
        
        @available(iOS 15.0, *)
        init?(from interruptionLevel: UNNotificationInterruptionLevel) {
            switch interruptionLevel {
            case .passive:
                self = .passive
            case .active:
                self = .active
            case .timeSensitive:
                self = .timeSensitive
            case .critical:
                self = .critical
            @unknown default:
                return nil
            }
        }
    }
}
