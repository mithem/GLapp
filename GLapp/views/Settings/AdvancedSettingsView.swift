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
    @AppStorage(UserDefaultsKeys.reprPlanNotificationsHighRelevanceTimeInterval) var reprPlanNotificationHighRelevanceTimeInterval = Constants.defaultReprPlanNotificationsHighRelevanceTimeInterval
    var body: some View {
        Form {
            Button("show_scheduled_notifications") {
                showingScheduledNotificationsView = true
            }
            .disabled(appManager.notifications.isEnabled != .yes)
            .sheet(isPresented: $showingScheduledNotificationsView) {
                ScheduledNotificationsView()
            }
            Stepper(NSLocalizedString("repr_plan_notifications_high_relevance_colon") + GLDateFormatter.relativeDateTimeFormatter.localizedString(fromTimeInterval: reprPlanNotificationHighRelevanceTimeInterval), value: $reprPlanNotificationHighRelevanceTimeInterval, in: 3600...24 * 3600, step: 3600)
        }
        .navigationTitle("advanced_settings")
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView(appManager: .init(), dataManager: MockDataManager())
    }
}
