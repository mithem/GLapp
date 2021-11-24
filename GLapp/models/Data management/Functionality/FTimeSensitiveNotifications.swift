//
//  FTimeSensitiveNotifications.swift
//  GLapp
//
//  Created by Miguel Themann on 24.11.21.
//

import Foundation
import UIKit

class FTimeSensitiveNotifications: Functionality {
    
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        NotificationManager.default.getNotificationsSettings { settings in
            if #available(iOS 15, *) {
                if settings.timeSensitiveSetting == .notSupported {
                    self.isSupported = .no
                } else {
                    self.isSupported = .yes // dependencies (notifications) verified independently
                }
            } else {
                self.isSupported = .no
            }
        }
    }
    
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        NotificationManager.default.getNotificationsSettings { settings in
            if #available(iOS 15, *) {
                if settings.timeSensitiveSetting == .enabled {
                    self.isEnabled = .yes
                } else {
                    self.isEnabled = .no // disabled & unsupported
                }
            } else {
                self.isEnabled = .no
            }
        }
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager, tappedByUser: Bool) throws {
        if tappedByUser {
            DispatchQueue.main.async {
                UIApplication.shared.open(.init(string: UIApplication.openSettingsURLString)!)
            }
        } else {
            throw Error.notAuthorized
        }
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        // Dunno what to do 
    }
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.timeSensitiveNotifications, role: .optional, dependencies: [.notifications])
    }
    
    override var mayRequireUsersAttention: Functionality.State {
        isEnabled.reversed
    }
}
