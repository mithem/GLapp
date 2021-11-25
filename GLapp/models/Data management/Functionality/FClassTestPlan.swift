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
        if isSupported == .yes && dataManager.classTestPlan == nil { // didn't load yet
            isSupported = UserDefaults.standard.bool(forKey: UserDefaultsKeys.classTestPlanNotSupported) ? .no : .yes
        } else if !isSupported.unwrapped {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.classTestPlanNotSupported)
        }
        if isSupported == .no {
            throw GLappError.classTestPlanNotSupported
        }
    }
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        isEnabled = isSupported
    }
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        if dataManager.tasks.getClassTestPlan.error == .classTestPlanNotSupported {
            throw Error.notSupported(message: "class_test_plan_not_supported")
        }
        appManager.classTestReminders.scheduleClassTestRemindersIfAppropriate(with: dataManager)
    }
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        try appManager.classTestReminders.disable(with: appManager, dataManager: dataManager)
    }
    
    func reset() {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.classTestPlanNotSupported)
    }
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.classTestPlan, role: .optional, dependencies: [])
    }
}
