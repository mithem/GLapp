//
//  SettingsView+LoginViewDelegate.swift
//  SettingsView+LoginViewDelegate
//
//  Created by Miguel Themann on 10.10.21.
//

import Foundation

extension SettingsView: LoginViewDelegate {
    func didSaveWithSuccess() {
        dataManager.reset()
        dataManager.loadData()
    }
}
