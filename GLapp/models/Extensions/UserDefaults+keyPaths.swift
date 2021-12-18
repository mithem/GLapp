//
//  UserDefaults+keyPaths.swift
//  GLapp
//
//  Created by Miguel Themann on 17.12.21.
//

import Foundation

extension UserDefaults {
    func set<ValueType>(_ value: ValueType?, for key: KeyPath<UserDefaultsKeys, String>) where ValueType: Codable {
        var isDirectlySupported = false
        if value is Bool || value is Int || value is Double || value is String || value is Data {
            isDirectlySupported = true
        }
        if isDirectlySupported {
            set(value, forKey: UserDefaultsKeys()[keyPath: key])
        } else {
            if let value = value {
                set(try? JSONEncoder().encode(value), forKey: UserDefaultsKeys()[keyPath: key])
            } else {
                set(nil, forKey: UserDefaultsKeys()[keyPath: key])
            }
        }
    }
    
    func setNil(for key: KeyPath<UserDefaultsKeys, String>) {
        set(nil, forKey: UserDefaultsKeys()[keyPath: key])
    }
    
    func bool(for key: KeyPath<UserDefaultsKeys, String>) -> Bool {
        bool(forKey: UserDefaultsKeys()[keyPath: key])
    }
    
    func integer(for key: KeyPath<UserDefaultsKeys, String>) -> Int {
        integer(forKey: UserDefaultsKeys()[keyPath: key])
    }
    
    func double(for key: KeyPath<UserDefaultsKeys, String>) -> Double {
        double(forKey: UserDefaultsKeys()[keyPath: key])
    }
    
    func string(for key: KeyPath<UserDefaultsKeys, String>) -> String? {
        string(forKey: UserDefaultsKeys()[keyPath: key])
    }
    
    func data(for key: KeyPath<UserDefaultsKeys, String>) -> Data? {
        data(forKey: UserDefaultsKeys()[keyPath: key])
    }
    
    func object<ValueType>(for key: KeyPath<UserDefaultsKeys, String>, decodeTo: ValueType.Type) -> ValueType? where ValueType: Codable {
        if let data = data(for: key) {
            return try? JSONDecoder().decode(ValueType.self, from: data)
        }
        return nil
    }
}
