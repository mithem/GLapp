//
//  SettingsViewDelegate.swift
//  GLapp
//
//  Created by Miguel Themann on 18.12.21.
//

import Foundation

protocol SettingsViewIsEnabledBindingResultHandling {
    func handleIsEnabledBindingResult(_ result: Result<Void, Functionality.Error>)
}
