//
//  FBackgroundReprPlanNotifications.swift
//  FBackgroundReprPlanNotifications
//
//  Created by Miguel Themann on 21.10.21.
//

import Foundation

class FBackgroundReprPlanNotifications: Functionality {
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        isEnabled = UserDefaults.standard.bool(for: \.backgroundReprPlanNotificationsEnabled) ? .yes : .no
    }
    
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        isSupported = .yes
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        try appManager.notifications.enable(with: appManager, dataManager: dataManager)
        UserDefaults.standard.set(true, for: \.backgroundReprPlanNotificationsEnabled)
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(false, for: \.backgroundReprPlanNotificationsEnabled)
    }
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.backgroundReprPlanNotifications, role: .optional, dependencies: [.notifications, .backgroundRefresh])
    }
}
