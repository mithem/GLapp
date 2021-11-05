//
//  FClassTestReminders.swift
//  FClassTestReminders
//
//  Created by Miguel Themann on 21.10.21.
//

import Foundation

class FClassTestReminders: Functionality {
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        isEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.automaticallyRemindBeforeClassTests) ? .yes : .no
    }
    
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        isSupported = .yes
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.automaticallyRemindBeforeClassTests)
        if appManager.notifications.isEnabled != .yes {
            try appManager.notifications.enable(with: appManager, dataManager: dataManager)
        }
        scheduleClassTestRemindersIfAppropriate(with: dataManager)
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.automaticallyRemindBeforeClassTests)
        NotificationManager.default.removeScheduledClassTestReminders()
    }
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.classTestReminders, role: .optional, dependencies: [.notifications])
    }
    
    func scheduleClassTestRemindersIfAppropriate(with dataManager: DataManager) {
        guard UserDefaults.standard.bool(forKey: UserDefaultsKeys.automaticallyRemindBeforeClassTests) else { // not using isEnabled as that's reloaded after doEnable runs
            return
        }
        guard let plan = dataManager.classTestPlan else { return }
        NotificationManager.default.removeScheduledClassTestReminders() {
            NotificationManager.default.scheduleClassTestsReminders(for: plan.classTests)
        }
    }
}
