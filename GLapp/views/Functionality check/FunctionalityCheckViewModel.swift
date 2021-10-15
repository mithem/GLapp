//
//  FunctionalityCheckViewModel.swift
//  FunctionalityCheckViewModel
//
//  Created by Miguel Themann on 15.10.21.
//

import Foundation
import UIKit

class FunctionalityCheckViewModel: ObservableObject {
    @Published var notificationsEnabled: Bool
    @Published var backgroundReprPlanCheckEnabled: Bool
    
    init() {
        notificationsEnabled = false
        backgroundReprPlanCheckEnabled = false
        refreshData()
    }
    
    func refreshData() {
        checkForNotifications()
        checkForBackgroundReprPlanCheck()
    }
    
    func checkForNotifications() {
        NotificationManager.checkNotificationsEnabled() { enabled in
            DispatchQueue.main.async {
                self.notificationsEnabled = enabled
            }
        }
    }
    
    func checkForBackgroundReprPlanCheck() {
        DispatchQueue.main.async {
            self.backgroundReprPlanCheckEnabled = BackgroundTaskManager.checkForBackgroundReprPlanCheckEnabled()
        }
    }
    
    func enableNotifications() {
        UIApplication.shared.open(.init(string: UIApplication.openSettingsURLString)!)
    }
    
    func enableBackgroundTasks() {
        UIApplication.shared.open(.init(string: UIApplication.openSettingsURLString)!)
    }
}
