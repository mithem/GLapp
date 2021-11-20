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
                        TestNotificationButton
                    }
                } else {
                    List {
                        ForEach(model.notifications) { notificationRequest in
                            ScheduledNotificationInlineView(request: notificationRequest)
                        }
                        TestNotificationButton
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
    
    var TestNotificationButton: some View {
        let btn = Button("test_notification") {
            model.showingTestNotificationConfirmationDialog = true
        }
        return Group {
            if #available(iOS 15, *) {
                btn
                    .confirmationDialog("test_notification", isPresented: model.binding(\.showingTestNotificationConfirmationDialog)) {
                        Button("test_notification") {
                            model.sendTestNotification()
                        }
                        Button("current_repr_plan") {
                            model.sendCurrentPlanNotification()
                        }
                    }
            } else {
                btn
                    .actionSheet(isPresented: model.binding(\.showingTestNotificationConfirmationDialog)) {
                        ActionSheet(title: Text("test_notification"), buttons: [
                            .default(Text("test_notification"), action: {
                                model.sendTestNotification()
                            }),
                            .default(Text("current_repr_plan"), action: {
                                model.sendCurrentPlanNotification()
                            })
                        ])
                    }
            }
        }
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
