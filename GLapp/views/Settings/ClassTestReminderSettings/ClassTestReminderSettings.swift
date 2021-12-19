//
//  ClassTestReminderSettings.swift
//  GLapp
//
//  Created by Miguel Themann on 18.12.21.
//

import SwiftUI

struct ClassTestReminderSettings: View {
    @AppStorage(UserDefaultsKeys().classTestReminderNotificationBeforeDays) var remindNDaysBeforeClassTests = Constants.defaultClassTestReminderNotificationsBeforeDays
    @AppStorage(UserDefaultsKeys().classTestReminderTimeMode) var classTestReminderTimeMode = ClassTestReminderTimeMode.atClassTestTime
    @State private var classTestReminderTimeManualTime = Constants.defaultClassTestReminderManualTime
    @ObservedObject var dataManager: DataManager
    @ObservedObject var appManager: AppManager
    let handler: SettingsViewIsEnabledBindingResultHandling
    var body: some View {
        Form {
            Toggle(appManager.classTestReminders.title, isOn: appManager.classTestReminders.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult))
            Stepper(value: $remindNDaysBeforeClassTests, in: 1...31) {
                Text(NSLocalizedString("remind_n_days_before_class_tests_colon") + String(remindNDaysBeforeClassTests))
                    .lineLimit(nil) // not sure why that was a problem
            }
                .onChange(of: remindNDaysBeforeClassTests) { _ in
                    appManager.classTestReminders.scheduleClassTestRemindersIfAppropriate(with: dataManager)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.5)
                }
            Picker("class_test_reminder_time_mode", selection: $classTestReminderTimeMode) {
                Text("class_test_reminder_time_mode_at_class_test_time").tag(ClassTestReminderTimeMode.atClassTestTime)
                Text("class_test_reminder_time_mode_manual").tag(ClassTestReminderTimeMode.manual)
            }
                .pickerStyle(.segmented)
                .onChange(of: classTestReminderTimeMode) { mode in
                    UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: Constants.segmentedControlValueChangedImpactFeedbackIntensity)
                }
            if classTestReminderTimeMode == .manual {
                DatePicker("class_test_reminder_time_time", selection: $classTestReminderTimeManualTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .onAppear {
                        classTestReminderTimeManualTime = UserDefaults.standard.object(for: \.classTestReminderManualTime, decodeTo: Date.self) ?? Constants.defaultClassTestReminderManualTime
                    }
                    .onDisappear {
                        UserDefaults.standard.set(classTestReminderTimeManualTime, for: \.classTestReminderManualTime)
                        appManager.classTestReminders.scheduleClassTestRemindersIfAppropriate(with: dataManager)
                    }
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
