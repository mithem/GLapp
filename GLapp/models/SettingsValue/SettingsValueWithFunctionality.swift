//
//  SettingsValueWithFunctionality.swift
//  GLapp
//
//  Created by Miguel Themann on 13.01.22.
//

import SwiftUI

class SettingsValueWithFunctionality<FType>: SettingsValue<Bool> where FType: Functionality {
    let functionality: KeyPath<AppManager, FType>
    
    init(key: KeyPath<UserDefaultsKeys, String>, functionality functionalityKey: KeyPath<AppManager, FType>, defaultValue: Bool) {
        self.functionality = functionalityKey
        super.init(key: key, defaultValue: defaultValue)
    }
    
    func set(to value: Bool, appManager: AppManager, dataManager: DataManager, setCompletion: Functionality.SetCompletion) {
        do {
            if value {
                try appManager[keyPath: functionality].enable(with: appManager, dataManager: dataManager)
            } else {
                try appManager[keyPath: functionality].disable(with: appManager, dataManager: dataManager)
            }
            setCompletion(.success(Void()))
        } catch {
            if let error = error as? Functionality.Error {
                setCompletion(.failure(error))
            } else {
                setCompletion(.failure(.notSupported(message: "SettingsValueWithFunctionality.set(to:appManager:dataManager:) got invalid error from Functionality.enable(with:dataManager:)/disable(with:dataManager:).")))
            }
        }
    }
    
    func functionalityBinding(appManager: AppManager, dataManager: DataManager, setCompletion: @escaping Functionality.SetCompletion) -> Binding<Bool> {
        appManager[keyPath: functionality].isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: setCompletion)
    }
}
