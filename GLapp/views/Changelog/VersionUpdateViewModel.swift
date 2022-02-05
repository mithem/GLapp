//
//  VersionUpdateViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 04.02.22.
//

import Foundation

class VersionUpdateViewModel: ObservableObject {
    @Published var appManager: AppManager
    @Published var dataManager: DataManager
    @Published var update: VersionUpdate
    @Published var showingPromoView: Bool
    
    init(appManager: AppManager, dataManager: DataManager, update: VersionUpdate) {
        self.appManager = appManager
        self.dataManager = dataManager
        self.update = update
        showingPromoView = false
    }
}
