//
//  ScheduledNotificationsViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 02.11.21.
//

import Foundation

class ScheduledNotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationManager.NotificationRequest]
    let timer = Timer.publish(every: 2, tolerance: nil, on: .current, in: .common).autoconnect()
    
    init() {
        notifications = []
        reload()
    }
    
    func reload() {
        NotificationManager.default.getScheduledClassTestReminders { requests in
            DispatchQueue.main.async {
                self.notifications = .init(requests).sorted(by: {$0.triggerDate ?? .distantPast < $1.triggerDate ?? .distantFuture})
            }
        }
    }
}
