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
        isEnabled = UserDefaults.standard.bool(for: \.coloredInlineSubjects) ? .yes : .no
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(true, for: \.coloredInlineSubjects)
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(false, for: \.coloredInlineSubjects)
    }
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.coloredInlineSubjects, role: .optional, dependencies: [])
    }
}
