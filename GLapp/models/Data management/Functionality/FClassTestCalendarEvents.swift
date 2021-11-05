//
//  FClassTestCalendarEvents.swift
//  GLapp
//
//  Created by Miguel Themann on 03.11.21.
//

import Foundation

class FClassTestCalendarEvents: Functionality {
    
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        isSupported = .yes
    }
    
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        isEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.classTestCalendarEvents) ? .yes : .no
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        if appManager.calendarAccess.isEnabled != .yes {
            try appManager.calendarAccess.enable(with: appManager, dataManager: dataManager)
        }
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.classTestCalendarEvents)
        createOrModifyClassTestCalendarEventsIfAppropriate(with: appManager, dataManager: dataManager)
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.classTestCalendarEvents)
    }
    
    func createOrModifyClassTestCalendarEventsIfAppropriate(with appManager: AppManager, dataManager: DataManager) {
        guard appManager.calendarAccess.isEnabled == .yes else { return }
        guard let plan = dataManager.classTestPlan else { return }
        EventManager.default.createClassTestEvents(from: plan.classTests) { _ in }
    }
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.classTestCalendarEvents, role: .optional, dependencies: [.calendarAccess, .classTestPlan])
    }
}