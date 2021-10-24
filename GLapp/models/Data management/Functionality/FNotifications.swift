//
//  FNotifications.swift
//  FNotifications
//
//  Created by Miguel Themann on 21.10.21.
//

import UserNotifications
import UIKit

/// Functionality notifications
class FNotifications: Functionality {
    /// Whether the current notification authorization is restricted by any means, e.g. by having a .ephemeral or .provisional authoriation status
    @Published var unrestrictedAuthorization: Bool
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        NotificationManager.default.getNotificationStatus() { status in
            self.isEnabled = status.validAuthoriatization ? .yes : .no
            self.unrestrictedAuthorization = status == .authorized
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
        unrestrictedAuthorization = false
        super.init(id: Constants.Identifiers.Functionalities.notifications, role: .critical, dependencies: [])
    }
}
