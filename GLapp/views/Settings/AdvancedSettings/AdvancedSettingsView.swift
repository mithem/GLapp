//
//  AdvancedSettingsView.swift
//  GLapp
//
//  Created by Miguel Themann on 05.11.21.
//

import SwiftUI

struct AdvancedSettingsView: View {
    @ObservedObject var model: AdvancedSettingsViewModel
    @State private var showingScheduledNotificationsView = false
    @State private var provisionalAuthorization = false
    @AppStorage(UserDefaultsKeys().reprPlanNotificationsHighRelevanceTimeInterval) var reprPlanNotificationHighRelevanceTimeInterval = SettingsStore().reprPlanNotificationsHighRelevanceTimeInterval.defaultValue
    @AppStorage(UserDefaultsKeys().reprPlanNotificationsEntireReprPlan) var reprPlanNotificationsEntireReprPlan = SettingsStore().reprPlanNotificationsEntireReprPlan.defaultValue
    @AppStorage(UserDefaultsKeys().dontSaveReprPlanUpdateTimestampWhenViewingReprPlan) var dontSaveReprPlanUpdateTimestampWhenViewingReprPlan = SettingsStore().dontSaveReprPlanUpdateTimestampWhenViewingReprPlan.defaultValue
    @AppStorage(UserDefaultsKeys().backgroundReprPlanCheckTimeInterval) var backgroundReprPlanCheckTimeInterval = SettingsStore().backgroundReprPlanCheckTimeInterval.defaultValue
    var body: some View {
        Form {
            Section {
                Button("regenerate_colors", action: model.dataManager.regenerateColors)
            }
            if model.appManager.notifications.isEnabled.unwrapped {
                Section {
                    Button("show_scheduled_notifications") {
                        showingScheduledNotificationsView = true
                    }
                    .disabled(!model.appManager.notifications.isEnabled.unwrapped)
                    .sheet(isPresented: $showingScheduledNotificationsView) {
                        ScheduledNotificationsView(dataManager: model.dataManager)
                    }
                }
                Section {
                    Stepper(settingsValue: \.reprPlanNotificationsHighRelevanceTimeInterval) {
                        GLDateFormatter.dateComponentsFormatter.string(from: .init(second: Int(reprPlanNotificationHighRelevanceTimeInterval))) ?? "not_available"
                    }
                    .onChange(of: reprPlanNotificationHighRelevanceTimeInterval) {_ in
                        Constants.FeedbackGenerator.didChangeSegmentedControlValue()
                    }
                    Text("repr_plan_notifications_high_relevance_explanation")
                        .foregroundColor(.secondary)
                }
                Section {
                    Stepper(settingsValue: \.backgroundReprPlanCheckTimeInterval) {
                        GLDateFormatter.dateComponentsFormatter.string(from: .init(second: Int(backgroundReprPlanCheckTimeInterval))) ?? NSLocalizedString("not_available")
                    }
                    .onChange(of: backgroundReprPlanCheckTimeInterval) {_ in
                        Constants.FeedbackGenerator.didChangeSegmentedControlValue()
                    }
                    .onDisappear {
                        BackgroundTaskManager.cancelBackgroundRepresentativePlanCheck()
                        BackgroundTaskManager.scheduleRepresentativeCheckTask()
                    }
                    Text("background_check_minimum_time_interval_explanation")
                        .foregroundColor(.secondary)
                }
                Section {
                    Toggle(settingsValue: \.reprPlanNotificationsEntireReprPlan, title: "repr_plan_notifications_send_entire_repr_plan")
                    Text("repr_plan_notifications_send_entire_repr_plan_explanation")
                        .foregroundColor(.secondary)
                }
                Section {
                    Toggle(settingsValue: \.dontSaveReprPlanUpdateTimestampWhenViewingReprPlan, title: "dont_save_repr_plan_update_timestamp_when_viewing_app")
                    Text("dont_save_repr_plan_update_timestamp_when_viewing_app_explanation")
                        .foregroundColor(.secondary)
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
        .onAppear(perform: model.onAppear)
        .navigationTitle("advanced_settings")
    }
    
    init(appManager: AppManager, dataManager: DataManager) {
        model = .init(appManager: appManager, dataManager: dataManager)
    }
}

#if DEBUG
struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView(appManager: .init(), dataManager: MockDataManager())
    }
}
#endif
