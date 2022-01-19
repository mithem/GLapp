//
//  ClassTestReminderSettings.swift
//  GLapp
//
//  Created by Miguel Themann on 18.12.21.
//

import SwiftUI

struct ClassTestReminderSettings: View {
    @AppStorage(UserDefaultsKeys().classTestReminderNotificationBeforeDays) var classTestRemindersRemindBeforeDays = SettingsStore().classTestRemindersRemindBeforeDays.defaultValue
    @State private var classTestReminderTimeManualTime = SettingsStore().classTestRemindersManualTime.defaultValue
    @ObservedObject var dataManager: DataManager
    @ObservedObject var appManager: AppManager
    let handler: SettingsViewIsEnabledBindingResultHandling
    var body: some View {
        Form {
            Toggle(settingsValue: \.classTestReminders, appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult)
            Stepper(settingsValue: \.classTestRemindersRemindBeforeDays) {
                NSLocalizedString("remind_n_days_before_class_tests_colon") + String(classTestRemindersRemindBeforeDays)
            }
            .onChange(of: classTestRemindersRemindBeforeDays) { _ in
                Constants.FeedbackGenerator.didChangeStepperValue()
            }
            Picker(settingsValue: appManager.settingsStore.classTestRemindersTimeMode, title: "class_test_reminder_time_mode") {
                Text("class_test_reminder_time_mode_at_class_test_time").tag(ClassTestReminderTimeMode.atClassTestTime)
                Text("class_test_reminder_time_mode_manual").tag(ClassTestReminderTimeMode.manual)
            }
                .pickerStyle(.segmented)
            DatePicker("class_test_reminder_time_manual_time", selection: $classTestReminderTimeManualTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.compact)
                .onAppear {
                    classTestReminderTimeManualTime = UserDefaults.standard.object(for: \.classTestReminderManualTime, decodeTo: Date.self) ?? SettingsStore().classTestRemindersManualTime.defaultValue
                }
                .onDisappear {
                    UserDefaults.standard.set(classTestReminderTimeManualTime, for: \.classTestReminderManualTime)
                    appManager.classTestReminders.scheduleClassTestRemindersIfAppropriate(with: dataManager)
                }
        }
        .navigationTitle("class_test_reminders")
    }
}

struct ClassTestReminderSettings_Previews: PreviewProvider {
    static var previews: some View {
        ClassTestReminderSettings(dataManager: MockDataManager(), appManager: .init(), handler: self as! SettingsViewIsEnabledBindingResultHandling)
    }
    
    func handleIsEnabledBindingResult(_ result: Result<Void, Functionality.Error>) {}
}
