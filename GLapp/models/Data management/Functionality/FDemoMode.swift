//
//  FDemoMode.swift
//  GLapp
//
//  Created by Miguel Themann on 23.10.21.
//

import Foundation

class FDemoMode: Functionality {
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        isSupported = .yes
    }
    
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        isEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.demoMode) ? .yes : .no
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.demoMode)
        dataManager.reset()
        dataManager.loadData()
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.demoMode)
        dataManager.reset()
        dataManager.loadData()
    }
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.demoMode, role: .critical, dependencies: []) // critical for App Store review
    }
}
