//
//  FColoredInlineSubjects.swift
//  GLapp
//
//  Created by Miguel Themann on 31.10.21.
//

import Foundation

class FColoredInlineSubjects: Functionality {
    
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        isSupported = .yes
    }
    
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        isEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.coloredInlineSubjects) ? .yes : .no
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.coloredInlineSubjects)
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.coloredInlineSubjects)
    }
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.coloredInlineSubjects, role: .optional, dependencies: [])
    }
}
