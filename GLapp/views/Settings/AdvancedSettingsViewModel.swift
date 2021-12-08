//
//  AdvancedSettingsViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 03.12.21.
//

import Foundation

final class AdvancedSettingsViewModel: ObservableObject {
    @Published var appManager: AppManager
    @Published var dataManager: DataManager
    
    init(appManager: AppManager, dataManager: DataManager) {
        self.appManager = appManager
        self.dataManager = dataManager
    }
    
    func onAppear() {
        appManager.reload(with: dataManager)
    }
}
