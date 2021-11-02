//
//  ScheduledNotificationInlineView.swift
//  GLapp
//
//  Created by Miguel Themann on 02.11.21.
//

import SwiftUI

struct ScheduledNotificationInlineView: View {
    let request: NotificationManager.NotificationRequest
    var body: some View {
        HStack {
            Text(request.summary)
            Spacer()
            Text(GLDateFormatter.localFormatter.string(from: request.triggerDate))
                .foregroundColor(.secondary)
        }
    }
}

struct ScheduledNotificationInlineView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledNotificationInlineView(request: .init(triggerDate: .rightNow, id: Constants.Identifiers.Notifications.classTestNotification, content: "Hello, world!"))
    }
}
