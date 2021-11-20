//
//  FBackgroundRefresh.swift
//  FBackgroundRefresh
//
//  Created by Miguel Themann on 21.10.21.
//

import UIKit

/// Functionality background refresh
class FBackgroundRefresh: Functionality {
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        if !BackgroundTaskManager.checkForBackgroundReprPlanCheckEnabled() {
            isEnabled = .no
        } else if ProcessInfo.processInfo.isLowPowerModeEnabled {
            isEnabled = .semi
        } else {
            isEnabled = .yes
        }
    }
    
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        isSupported = .yes
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        if ProcessInfo.processInfo.isLowPowerModeEnabled { throw Error.notSupported(message: "low_power_mode_enabled") }
        UIApplication.shared.open(.init(string: UIApplication.openSettingsURLString)!)
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {}
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.backgroundRefresh, role: .critical, dependencies: [])
    }
}
