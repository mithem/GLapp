//
//  ScheduledNotificationsView.swift
//  GLapp
//
//  Created by Miguel Themann on 02.11.21.
//

import SwiftUI

struct ScheduledNotificationsView: View {
    @ObservedObject private var model = ScheduledNotificationsViewModel()
    var body: some View {
        NavigationView {
            Group {
                if model.notifications.isEmpty {
                    VStack {
                        EmptyContentView(image: emptyContentImage, text: "no_scheduled_notifications")
                        AccentColorButton("test_notification") {
                            sendTestNotification()
                        }
                    }
                } else {
                    List {
                        ForEach(model.notifications) { notificationRequest in
                            ScheduledNotificationInlineView(request: notificationRequest)
                        }
                        Button("test_notification") {
                            sendTestNotification()
                        }
                    }
                }
            }
            .onReceive(model.timer) { timer in
                model.reload()
            }
            .onAppear {
                model.reload()
            }
            .navigationTitle("scheduled_notifications")
        }
    }
    
    var emptyContentImage: String {
        if #available(iOS 15, *) {
            return "circle.slash"
        } else {
            return "slash.circle"
        }
    }
    
    func sendTestNotification() {
        NotificationManager.default.deliverNotification(identifier: \.testNotification, title: "Test notification", body: "This is a test.", sound: .default, interruptionLevel: .timeSensitive, in: 0.0001)
    }
}

struct ScheduledNotfificationsViewPreviews: PreviewProvider {
    static var previews: some View {
        ScheduledNotificationsView()
    }
}
