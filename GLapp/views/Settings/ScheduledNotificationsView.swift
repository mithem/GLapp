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
                    EmptyContentView(image: emptyContentImage, text: "no_scheduled_notifications")
                } else {
                    List(model.notifications) { notificationRequest in
                        ScheduledNotificationInlineView(request: notificationRequest)
                    }
                }
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
}

struct ScheduledNotfificationsViewPreviews: PreviewProvider {
    static var previews: some View {
        ScheduledNotificationsView()
    }
}
