//
//  SettingsValueStrideable.swift
//  GLapp
//
//  Created by Miguel Themann on 14.01.22.
//

import Foundation

class SettingsValueStrideable<V>: SettingsValue<V> where V: Codable, V: Strideable {
    let range: ClosedRange<V>
    let step: V
    
    init(key: KeyPath<UserDefaultsKeys, String>, defaultValue: V, range: ClosedRange<V>, step: V, onChange: OnChangeCallback? = nil, hapticFeedback: Bool = false) {
        if !range.contains(defaultValue) {
            fatalError("Default value is out of supported range.")
        }
        if onChange != nil && hapticFeedback {
            fatalError("Both OnChangeCallback given & haptic feedback enabled. Only one supported.")
        }
        let callback: OnChangeCallback?
        if hapticFeedback {
            callback = { _ in
                Constants.FeedbackGenerator.didChangeStepperValue()
            }
        } else {
            callback = onChange
        }
        
        self.range = range
        self.step = step
        super.init(key: key, defaultValue: defaultValue, onChange: callback)
    }
    
    func selfRepair() {
        if let currentValue = getCurrentValue() {
            if !range.contains(currentValue) {
                resetToDefault()
            }
        }
    }
}
