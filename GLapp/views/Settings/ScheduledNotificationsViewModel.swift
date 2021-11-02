//
//  ScheduledNotificationsViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 02.11.21.
//

import Foundation

class ScheduledNotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationManager.NotificationRequest]
    
    init() {
        notifications = []
        reload()
    }
    
    func reload() {
        NotificationManager.default.getScheduledClassTestReminders { requests in
            DispatchQueue.main.async {
                self.notifications = .init(requests).sorted(by: {$0.triggerDate < $1.triggerDate})
            }
        }
    }
}
