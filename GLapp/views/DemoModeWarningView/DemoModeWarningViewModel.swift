//
//  DemoModeWarningViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 28.03.22.
//

import Foundation

class DemoModeWarningViewModel: ObservableObject {
    @Published var appManager: AppManager
    @Published var dataManager: DataManager
    
    func deactivateDemoMode() {
        try? appManager.demoMode.disable(with: appManager, dataManager: dataManager)
        dataManager.reset()
        resetLoginInfo()
    }
    
    init(appManager: AppManager, dataManager: DataManager) {
        self.appManager = appManager
        self.dataManager = dataManager
    }
}
