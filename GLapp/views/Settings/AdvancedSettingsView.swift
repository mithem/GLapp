//
//  AdvancedSettingsView.swift
//  GLapp
//
//  Created by Miguel Themann on 05.11.21.
//

import SwiftUI

struct AdvancedSettingsView: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var dataManager: DataManager
    @State private var showingScheduledNotificationsView = false
    var body: some View {
        Form {
            Button("show_scheduled_notifications") {
                showingScheduledNotificationsView = true
            }
            .disabled(appManager.notifications.isEnabled != .yes)
            .sheet(isPresented: $showingScheduledNotificationsView) {
                ScheduledNotificationsView()
            }
        }
        .navigationTitle("advanced_settings")
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView(appManager: .init(), dataManager: MockDataManager())
    }
}
