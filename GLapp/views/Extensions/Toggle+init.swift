//
//  Toggle+init.swift
//  GLapp
//
//  Created by Miguel Themann on 13.01.22.
//

import SwiftUI

extension Toggle {
    init(settingsValue: SettingsValue<Bool>, label: @escaping () -> String) where Label == Text {
        self.init(isOn: settingsValue.binding, label: {
            Text(NSLocalizedString(label()))
        })
    }
    
    init(settingsValue key: KeyPath<SettingsStore, SettingsValue<Bool>>, label: @escaping () -> String) where Label == Text {
        self.init(settingsValue: SettingsStore()[keyPath: key], label: label)
    }
    
    init(settingsValue: SettingsValue<Bool>, title: String) where Label == Text {
        self.init(isOn: settingsValue.binding, label: {
            Text(NSLocalizedString(title))
        })
    }
    
    init(settingsValue key: KeyPath<SettingsStore, SettingsValue<Bool>>, title: String) where Label == Text {
        self.init(settingsValue: SettingsStore()[keyPath: key], title: title)
    }
    
    init<FType>(settingsValue: SettingsValueWithFunctionality<FType>, appManager: AppManager, dataManager: DataManager, setCompletion: @escaping Functionality.SetCompletion) where Label == Text {
        self.init(settingsValue: settingsValue, title: appManager[keyPath: settingsValue.functionality].title)
        self.init(isOn: settingsValue.functionalityBinding(appManager: appManager, dataManager: dataManager, setCompletion: setCompletion), label: {
            Text(NSLocalizedString(appManager[keyPath: settingsValue.functionality].title))
        })
    }
    
    init<FType>(settingsValue key: KeyPath<SettingsStore, SettingsValueWithFunctionality<FType>>, appManager: AppManager, dataManager: DataManager, setCompletion: @escaping Functionality.SetCompletion) where Label == Text {
        self.init(settingsValue: SettingsStore()[keyPath: key], appManager: appManager, dataManager: dataManager, setCompletion: setCompletion)
    }
}
