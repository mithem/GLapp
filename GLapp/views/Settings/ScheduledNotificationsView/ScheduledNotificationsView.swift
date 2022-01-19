//
//  ScheduledNotificationsView.swift
//  GLapp
//
//  Created by Miguel Themann on 02.11.21.
//

import SwiftUI

struct ScheduledNotificationsView: View {
    @ObservedObject private var model: ScheduledNotificationsViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if model.notifications.isEmpty {
                    VStack {
                        EmptyContentView(image: model.emptyContentImage, text: "no_scheduled_notifications")
                        AccentColorButton("test_notification", action: testNotificationBtn)
                    }
                } else {
                    List {
                        ForEach(model.notifications) { notificationRequest in
                            ScheduledNotificationInlineView(request: notificationRequest)
                        }
                        Button("test_notification", action: testNotificationBtn)
                    }
                }
            }
            .confirmationDialog(provider: model, actionButtons: [(title: "test_notification", callback: model.sendTestNotification), (title: "current_repr_plan", callback: model.sendCurrentPlanNotification)], cancelButtons: [(title: "cancel", callback: {})])
            .onReceive(model.timer) { timer in
                model.reload()
            }
            .onAppear {
                model.reload()
            }
            .navigationTitle("scheduled_notifications")
        }
    }
    
    func testNotificationBtn() {
        model.showingConfirmationDialog = true
    }
    
    init(dataManager: DataManager) {
        model = .init(dataManager: dataManager)
    }
}

struct ScheduledNotfificationsViewPreviews: PreviewProvider {
    static var previews: some View {
        ScheduledNotificationsView(dataManager: MockDataManager())
    }
}
