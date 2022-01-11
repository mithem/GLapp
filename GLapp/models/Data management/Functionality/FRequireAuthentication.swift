//
//  FAuthentication.swift
//  GLapp
//
//  Created by Miguel Themann on 10.01.22.
//

import Foundation
import LocalAuthentication

final class FRequireAuthentication: Functionality {
    @Published var didFailAuthenticationWhenEnabling: Bool
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        if didFailAuthenticationWhenEnabling {
            throw Functionality.Error.notAuthorized
        }
        isSupported = .yes
    }
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        isEnabled = UserDefaults.standard.bool(for: \.requireAuthentication) ? .yes : .no
    }
    
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            UserDefaults.standard.set(true, for: \.requireAuthentication)
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: appManager.requireAuthentication.description) { success, _ in
                self.didFailAuthenticationWhenEnabling = !success
            }
        } else {
            throw Functionality.Error.notAuthorized
        }
    }
    
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        UserDefaults.standard.set(false, for: \.requireAuthentication)
    }
    
    /// Use if AppManager cannot be reloaded early enough before `isEnabled` state needs to be checked
    class func checkIfEnabled() -> Functionality.State {
        UserDefaults.standard.bool(for: \.requireAuthentication) ? .yes : .no
    }
    
    required init() {
        didFailAuthenticationWhenEnabling = false
        super.init(id: Constants.Identifiers.Functionalities.requireAuthentication, role: .optional, dependencies: [])
    }
}
