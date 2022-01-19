//
//  AppStorage+init.swift
//  GLapp
//
//  Created by Miguel Themann on 15.01.22.
//

import SwiftUI

extension AppStorage {
    init(_ wrappedValue: SettingsValue<Int>, store: UserDefaults = .standard) where Value == Int {
        self.init(wrappedValue: wrappedValue.unwrapped, UserDefaultsKeys()[keyPath: wrappedValue.key], store: store)
    }
}
