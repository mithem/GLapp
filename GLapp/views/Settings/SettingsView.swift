//
//  SettingsView.swift
//  SettingsView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingLoginView = false
    @State private var showingFunctionalityCheckView = false
    @State private var functionalityError = Functionality.Error.notImplemented
    @AppStorage(UserDefaultsKeys.classTestReminderNotificationBeforeDays) var remindNDaysBeforeClassTests = Constants.defaultClassTestReminderNotificationsBeforeDays
    @ObservedObject var dataManager: DataManager
    @ObservedObject var appManager: AppManager
    @ObservedObject var confirmationDialogProvider: ConfirmationDialogProvider
    var FormView: some View {
        Form {
            Section {
                Button("check_for_functionality") {
                    showingFunctionalityCheckView = true
                }
                .sheet(isPresented: $showingFunctionalityCheckView) {
                    FunctionalityCheckView(appManager: appManager, dataManager: dataManager)
                }
                if dataManager.tasks.getClassTestPlan.error != .classTestPlanNotSupported {
                    Toggle(appManager.classTestReminders.title, isOn: appManager.classTestReminders.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handleIsEnabledBindingResult))
                    Stepper(value: $remindNDaysBeforeClassTests, in: 1...31) {
                        Text(NSLocalizedString("remind_n_days_before_class_tests_colon") + String(remindNDaysBeforeClassTests))
                            .lineLimit(nil) // not sure why that was a problem
                    }
                        .onChange(of: remindNDaysBeforeClassTests) { _ in
                            appManager.classTestReminders.scheduleClassTestRemindersIfAppropriate(with: dataManager)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.5)
                        }
                    Toggle(appManager.classTestCalendarEvents.title, isOn: appManager.classTestCalendarEvents.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handleIsEnabledBindingResult))
                }
                Toggle(appManager.backgroundReprPlanNotifications.title, isOn: appManager.backgroundReprPlanNotifications.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handleIsEnabledBindingResult))
                Toggle(appManager.coloredInlineSubjects.title, isOn: appManager.coloredInlineSubjects.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handleIsEnabledBindingResult))
                if appManager.spotlightIntegration.isSupported.unwrapped {
                    Toggle(appManager.spotlightIntegration.title, isOn: appManager.spotlightIntegration.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handleIsEnabledBindingResult))
                }
                Link("feedback", destination: Constants.mailToURL)
                NavigationLink("advanced_settings") {
                    AdvancedSettingsView(appManager: appManager, dataManager: dataManager)
                }
            }
            Section {
                if !isLoggedIn() {
                    Button("login") {
                        showingLoginView = true
                    }
                }
                Button("clear_cache") {
                    dataManager.clearAllLocalData(withHapticFeedback: true)
                }
                Button("reset_onboarding") {
                    resetOnboarding(withHapticFeedback: true)
                }
                Group {
                    if #available(iOS 15, *) {
                        Button("reset_all_data", role: .destructive, action: resetAllData)
                    } else {
                        Button("reset_all_data", action: resetAllData)
                            .foregroundColor(.red)
                    }
                }
                .sheet(isPresented: $showingLoginView) {
                    LoginView(appManager: appManager, dataManager: dataManager, delegate: self)
                }
            }
            if appManager.demoMode.isEnabled.unwrapped {
                Section {
                    Button("demo_mode_active") {
                        try? appManager.demoMode.disable(with: appManager, dataManager: dataManager)
                    }
                }
            }
            if Constants.appVersion.isPrerelease {
                Text(NSLocalizedString("prerelease_version_exl_mark") + " (\(Constants.appVersion))")
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            appManager.reload(with: dataManager)
        }
        .onDisappear {
            appManager.reload(with: dataManager)
        }
        .confirmationDialog(provider: confirmationDialogProvider, actionButtons: [], cancelButtons: [(title: "ok", callback: {
            showingFunctionalityCheckView = true
        })])
        .navigationTitle("settings")
    }
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            FormView
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationView {
                FormView
            }
            .navigationViewStyle(.stack)
        }
    }
    
    func handleIsEnabledBindingResult(_ result: Result<Void, Functionality.Error>) {
            switch result {
            case .success():
                break
            case .failure(let error):
                confirmationDialogProvider.confirmationDialog?.body = error.localizedMessage
                confirmationDialogProvider.showingConfirmationDialog = true
            }
    }
    
    func resetAllData() {
        let generator = UINotificationFeedbackGenerator()
        resetAllDataOn(dataManager: dataManager, appManager: appManager)
        showingLoginView = true
        generator.notificationOccurred(.success)
    }
    
    init(dataManager: DataManager, appManager: AppManager) {
        self.dataManager = dataManager
        self.appManager = appManager
        self.confirmationDialogProvider = .init(title: "error_occured", body: "unkown_error")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(dataManager: MockDataManager(), appManager: .init())
    }
}
