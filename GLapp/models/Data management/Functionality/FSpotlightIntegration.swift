//
//  FSpotlightIntegration.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation
import UIKit

final class FSpotlightIntegration: Functionality {
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        isSupported = UIDevice.current.userInterfaceIdiom == .phone ? .yes : .no
    }
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        isEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.disableSpotlightIntegration) ? .no : .yes
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.disableSpotlightIntegration)
        dataManager.indexContent()
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.disableSpotlightIntegration)
        IntentsManager.reset()
    }
    
    required init() {
        super.init(id: Constants.Identifiers.Functionalities.spotlightIntegration, role: .optional, dependencies: [])
    }
}
