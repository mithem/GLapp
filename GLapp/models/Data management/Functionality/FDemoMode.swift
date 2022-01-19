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
        isEnabled = UserDefaults.standard.bool(for: \.demoMode) ? .yes : .no
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(true, for: \.demoMode)
        dataManager.reset()
        try appManager.classTestPlan.reload(with: appManager, dataManager: dataManager)
        DispatchQueue.global(qos: .background).async {
            dataManager.loadData()
        }
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(false, for: \.demoMode)
        dataManager.reset()
        dataManager.loadData()
    }
    
    func reset() {
        UserDefaults.standard.set(false, for: \.demoMode)
    }
    
    /// Just return whether demo mode is enabled. Does not interact with `isEnabled` or something else at all.
    ///
    /// Useful, when `AppManager` may not have reloaded yet.
    func checkIsEnabled() -> State {
        UserDefaults.standard.bool(for: \.demoMode) ? .yes : .no
    }
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.demoMode, role: .critical, dependencies: []) // critical for App Store review
    }
}
