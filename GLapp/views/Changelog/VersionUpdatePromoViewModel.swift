//
//  VersionUpdatePromoViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 04.02.22.
//

import Foundation
import Semver
import CoreGraphics

class VersionUpdatePromoViewModel: ObservableObject {
    @Published var appManager: AppManager
    @Published var dataManager: DataManager
    @Published var update: VersionUpdate
    @Published var showCloseButton: Bool
    
    init(appManager: AppManager, dataManager: DataManager, update: VersionUpdate? = nil, showCloseButton: Bool = false) {
        self.appManager = appManager
        self.dataManager = dataManager
        if let update = update {
            self.update = update
        } else {
            let fallback = Changelog.versionUpdates.first!
            if let lastLaunched = Semver(UserDefaults.standard.string(for: \.lastLaunchedVersion) ?? "") {
                self.update = (try? Changelog.getVersionUpdate(since: lastLaunched)) ?? fallback
            } else {
                self.update = fallback
            }
        }
        self.showCloseButton = showCloseButton
    }
}
