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
    @State private var provisionalAuthorization = false
    @AppStorage(UserDefaultsKeys.reprPlanNotificationsHighRelevanceTimeInterval) var reprPlanNotificationHighRelevanceTimeInterval = Constants.defaultReprPlanNotificationsHighRelevanceTimeInterval
    @AppStorage(UserDefaultsKeys.reprPlanNotificationsEntireReprPlan) var reprPlanNotificationsEntireReprPlan = false
    @AppStorage(UserDefaultsKeys.dontSaveReprPlanUpdateTimestampWhenViewingReprPlan) var dontSaveReprPlanUpdateTimestampWhenViewingReprPlan = false
    var body: some View {
        Form {
            if appManager.notifications.isEnabled.unwrapped {
                Section {
                    Button("show_scheduled_notifications") {
                        showingScheduledNotificationsView = true
                    }
                    .disabled(!appManager.notifications.isEnabled.unwrapped)
                    .sheet(isPresented: $showingScheduledNotificationsView) {
                        ScheduledNotificationsView()
                    }
                }
                Section {
                    Stepper(GLDateFormatter.dateComponentsFormatter.string(from: .init(hour: Int(reprPlanNotificationHighRelevanceTimeInterval / 3600))) ?? "not_available", value: $reprPlanNotificationHighRelevanceTimeInterval, in: 3600...24 * 3600, step: 3600)
                    Text(NSLocalizedString("repr_plan_notifications_high_relevance_explanation"))
                        .foregroundColor(.secondary)
                }
                Section {
                    Toggle("repr_plan_notifications_send_entire_repr_plan", isOn: $reprPlanNotificationsEntireReprPlan)
                    Text("repr_plan_notifications_send_entire_repr_plan_explanation")
                        .foregroundColor(.secondary)
                }
                if reprPlanNotificationsEntireReprPlan {
                    Section {
                        Toggle("dont_save_repr_plan_update_timestamp_when_viewing_app", isOn: $dontSaveReprPlanUpdateTimestampWhenViewingReprPlan)
                            .onChange(of: dontSaveReprPlanUpdateTimestampWhenViewingReprPlan) { dontSave in
                                if dontSave {
                                    removeLastReprPlanUpdateTimestamp()
                            }
                        }
                        Text("dont_save_repr_plan_update_timestamp_when_viewing_app_explanation")
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                Section {
                    Button("request_provisional_notification_permission") {
                        NotificationManager.default.requestNotificationAuthorization { success in
                            provisionalAuthorization = success
                        }
                    }
                }
            }
        }
        .onAppear {
            appManager.reload(with: dataManager)
        }
        .navigationTitle("advanced_settings")
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView(appManager: .init(), dataManager: MockDataManager())
    }
}
