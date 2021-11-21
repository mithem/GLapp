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
            VStack(alignment: .leading) {
                Text(request.notificationTitle)
                Text(request.notificationSummary)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(dateDescription ?? "not_available")
                .foregroundColor(.secondary)
        }
    }
    
    var dateDescription: String? {
        guard let triggerDate = request.triggerDate else { return nil }
        let formatter = GLDateFormatter.localFormatter
        formatter.dateStyle = .short
        return formatter.string(from: triggerDate)
    }
}

struct ScheduledNotificationInlineView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledNotificationInlineView(request: .init(id: \.testNotification, title: "Test notification", content: "This is the content", triggerDate: .rightNow + 10000, interruptionLevel: .active, relevance: 5))
    }
}
