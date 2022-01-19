//
//  ScheduledNotificationsViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 02.11.21.
//

import Foundation
import SwiftUI

class ScheduledNotificationsViewModel: ObservableObject, ConfirmationDialogProviding {
    @Published var dataManager: DataManager
    @Published var notifications: [NotificationManager.NotificationRequest]
    @Published var showingConfirmationDialog: Bool
    let timer = Timer.publish(every: 2, tolerance: nil, on: .current, in: .common).autoconnect()
    
    var confirmationDialog: (title: String, body: String)? {
        (title: "test_notification", body: "")
    }
    
    var emptyContentImage: String {
        if #available(iOS 15, *) {
            return "circle.slash"
        } else {
            return "slash.circle"
        }
    }
    
    func binding<ValueType>(_ path: ReferenceWritableKeyPath<ScheduledNotificationsViewModel, ValueType>) -> Binding<ValueType> {
        .init(get: {
            self[keyPath: path]
        }, set: { newValue in
            self[keyPath: path] = newValue
        })
    }
    
    @MainActor init(dataManager: DataManager) {
        self.dataManager = dataManager
        notifications = []
        showingConfirmationDialog = false
        reload()
    }
    
    func reload() {
        NotificationManager.default.getScheduledClassTestReminders { requests in
            DispatchQueue.main.async {
                self.notifications = .init(requests).sorted(by: {$0.triggerDate ?? .distantPast < $1.triggerDate ?? .distantFuture})
            }
        }
    }
    
    func sendTestNotification() {
        NotificationManager.default.deliverNotification(identifier: \.testNotification, title: "Test notification", body: "This is a test.", sound: .default, interruptionLevel: .timeSensitive, in: 0.0001)
    }
    
    func sendCurrentPlanNotification() {
        NotificationManager.default.deliverNotification(dataManager.representativePlan ?? .init(date: nil))
    }
}
