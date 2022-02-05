//
//  ChangelogViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 04.02.22.
//

import Foundation

class ChangelogViewModel: ObservableObject {
    @Published var appManager: AppManager
    @Published var dataManager: DataManager
    
    init(appManager: AppManager, dataManager: DataManager) {
        self.appManager = appManager
        self.dataManager = dataManager
    }
}
