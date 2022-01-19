//
//  Stepper+init.swift
//  GLapp
//
//  Created by Miguel Themann on 13.01.22.
//

import SwiftUI

extension Stepper {
    init<ValueType>(settingsValue: SettingsValueStrideable<ValueType>, label: @escaping () -> String) where ValueType: Strideable, ValueType: SignedNumeric, ValueType.Stride == ValueType, Label == Text {
        self.init(value: settingsValue.binding, in: settingsValue.range.lowerBound ... settingsValue.range.upperBound, step: settingsValue.step, label: {
            Text(NSLocalizedString(label()))
        }) // regarding that silly-looking range: best (easy) way I found to convert ClosedRange<V> to ClosedRange<V?>
    }
    
    init<ValueType>(settingsValue key: KeyPath<SettingsStore, SettingsValueStrideable<ValueType>>, label: @escaping () -> String) where ValueType: Strideable, ValueType: SignedNumeric, ValueType.Stride == ValueType, Label == Text {
        self.init(settingsValue: SettingsStore()[keyPath: key], label: label)
    }
}
