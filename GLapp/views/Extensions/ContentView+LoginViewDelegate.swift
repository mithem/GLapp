//
//  ContentView+LoginViewDelegate.swift
//  ContentView+LoginViewDelegate
//
//  Created by Miguel Themann on 10.10.21.
//

import Foundation

extension ContentView: LoginViewDelegate {
    func didSaveWithSuccess() {
        dataManager.loadData()
    }
}
