//
//  FNotifications.swift
//  FNotifications
//
//  Created by Miguel Themann on 21.10.21.
//

import UserNotifications
import UIKit

/// Functionality notifications
class FNotifications: Functionality{
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        NotificationManager.default.checkNotificationsEnabled() { enabled in
            self.isEnabled = enabled ? .yes : .no
        }
    }
    
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        isSupported = .yes
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        UIApplication.shared.open(.init(string: UIApplication.openSettingsURLString)!)
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {}
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.notifications, role: .critical, dependencies: [])
        self.isSupported = .yes
    }
}
