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
    
    override var stateDescription: String {
        switch isEnabled {
        case .yes:
            return "currently_enabled"
        case .no:
            return "currently_disabled"
        case .unknown:
            return "unkown_state"
        case .semi:
            return "permission_provisional_or_ephemeral"
        }
    }
    
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        NotificationManager.default.getAuthorizationStatus() { status in
            self.isEnabled = status.functionalityState
            self.unrestrictedAuthorization = status == .authorized
        }
    }
    
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        isSupported = .yes
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager, tappedByUser: Bool) throws {
        if !unrestrictedAuthorization {
            NotificationManager.default.requestNotificationAuthorization(unrestricted: true) { success in
                if !success && tappedByUser {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(.init(string: UIApplication.openSettingsURLString)!)
                    }
                }
            }
        }
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        NotificationManager.default.reset()
    }
    
    required init() {
        unrestrictedAuthorization = false
        super.init(id: Constants.Identifiers.Functionalities.notifications, role: .critical, dependencies: [])
    }
}
