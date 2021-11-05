//
//  FCalendarAccess.swift
//  GLapp
//
//  Created by Miguel Themann on 03.11.21.
//

import Foundation
import UIKit

class FCalendarAccess: Functionality {
    
    private var triedToEnableWithoutSuccess: Bool
    
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        guard !triedToEnableWithoutSuccess else { throw Error.notAuthorized }
        isSupported = .yes
    }
    
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        guard !triedToEnableWithoutSuccess else { throw Error.notAuthorized }
        isEnabled = EventManager.default.getAuthorizatonStatus().functionalityState
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        func openSettings() {
            DispatchQueue.main.async {
                UIApplication.shared.open(.init(string: UIApplication.openSettingsURLString)!)
            }
        }
        if triedToEnableWithoutSuccess {
            openSettings()
            return
        }
        EventManager.default.requestAuthorization { result in
            switch result {
            case .success(let granted):
                if !granted {
                    self.triedToEnableWithoutSuccess = true
                    openSettings()
                }
            case .failure(let error):
                print(error)
                self.triedToEnableWithoutSuccess = true
            }
        }
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        triedToEnableWithoutSuccess = false
    }
    
    override var mayRequireUsersAttention: Functionality.State {
        triedToEnableWithoutSuccess ? .yes : .no
    }
    
    required init() {
        triedToEnableWithoutSuccess = false
        super.init(id: Constants.Identifiers.Functionalities.calendarAccess, role: .critical, dependencies: [])
    }
}
