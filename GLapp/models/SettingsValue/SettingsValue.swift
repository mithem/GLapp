//
//  SettingsValue.swift
//  GLapp
//
//  Created by Miguel Themann on 12.01.22.
//

import SwiftUI
import Combine

class SettingsValue<V>: ObservableObject where V: Codable {
    typealias OnChangeCallback = (V?) -> Void
    
    let key: KeyPath<UserDefaultsKeys, String>
    let defaultValue: V
    let onChange: OnChangeCallback?
    @Published var currentValue: V?
    
    init(key: KeyPath<UserDefaultsKeys, String>, defaultValue: V, onChange: OnChangeCallback? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.currentValue = defaultValue
        self.onChange = onChange
        let currentValue = getCurrentValue()
        if let currentValue = currentValue {
            set(to: currentValue)
        } else {
            resetToDefault()
        }
    }
    
    func update() {
        set(to: getCurrentValue())
    }
    
    func getCurrentValue() -> V? {
        var value: V?
        if V.self == Double.self {
            value = (UserDefaults.standard.double(for: key) as! V)
            if value as! Double == 0.0 {
                value = nil
            }
        } else if V.self == Int.self {
            value = (UserDefaults.standard.integer(for: key) as! V)
            if value as! Int == 0 {
                value = nil
            }
        } else if V.self == Data.self {
            value = (UserDefaults.standard.data(for: key) as! V)
        } else if V.self == String.self {
            value = (UserDefaults.standard.string(for: key) as! V)
        } else if V.self == Bool.self {
            value = (UserDefaults.standard.bool(for: key) as! V)
        } else {
            value = (UserDefaults.standard.object(for: key, decodeTo: V.self))
        }
        return value
    }
    
    var binding: Binding<V> {
        .init(get: {
            self.currentValue ?? self.defaultValue
        }, set: { newValue in
            self.set(to: newValue)
        })
    }
    
    /// `currentValue`, but safely unwrapped with the default value.
    var unwrapped: V {
        currentValue ?? defaultValue
    }
    
    func set(to value: V?) {
        UserDefaults.standard.set(value, for: key)
        currentValue = value
        if let onChange = onChange {
            onChange(value)
        }
    }
    
    func resetToDefault() {
        set(to: defaultValue)
    }
}
