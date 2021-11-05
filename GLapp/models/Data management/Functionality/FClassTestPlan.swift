//
//  FClassTestPlan.swift
//  GLapp
//
//  Created by Miguel Themann on 03.11.21.
//

import Foundation

/// Weather the ClassTestPlan is actually supported by the school (cuz it's only for Oberstufe)
class FClassTestPlan: Functionality {
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        isSupported = dataManager.tasks.getClassTestPlan.error != .classTestPlanNotSupported ? .yes : .no
    }
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        isEnabled = .yes
    }
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        appManager.classTestReminders.scheduleClassTestRemindersIfAppropriate(with: dataManager)
    }
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        try appManager.classTestReminders.disable(with: appManager, dataManager: dataManager)
    }
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.classTestPlan, role: .optional, dependencies: [])
    }
}
