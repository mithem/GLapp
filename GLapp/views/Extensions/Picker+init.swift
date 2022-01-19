//
//  Picker+init.swift
//  GLapp
//
//  Created by Miguel Themann on 14.01.22.
//

import SwiftUI

extension Picker {
    init(settingsValue: SettingsValue<SelectionValue>, title: String, @ViewBuilder content: () -> Content) where Label == Text {
        self.init(selection: settingsValue.binding, content: content, label: {
            Text(NSLocalizedString(title))
        })
    }
    
    init(settingsValue key: KeyPath<SettingsStore, SettingsValue<SelectionValue>>, title: String, @ViewBuilder content: () -> Content) where Label == Text {
        self.init(settingsValue: SettingsStore()[keyPath: key], title: title, content: content)
    }
}
