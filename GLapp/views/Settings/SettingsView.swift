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
    @State private var showingErrorActionSheet = false
    @AppStorage(UserDefaultsKeys.classTestReminderNotificationBeforeDays) var remindNDaysBeforeClassTests = Constants.defaultClassTestReminderNotificationsBeforeDays
    @ObservedObject var dataManager: DataManager
    @ObservedObject var appManager: AppManager
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
                    Stepper(NSLocalizedString("remind_n_days_before_class_tests_colon") + String(remindNDaysBeforeClassTests), value: $remindNDaysBeforeClassTests, in: 1...31)
                        .onChange(of: remindNDaysBeforeClassTests) { _ in
                            appManager.classTestReminders.scheduleClassTestRemindersIfAppropriate(with: dataManager)
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
                Button("clear_cache", action: dataManager.clearAllLocalData)
                Button("reset_onboarding", action: resetOnboarding)
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
        .navigationTitle("settings")
    }
    
    var InnerView: some View {
        Group {
            if #available(iOS 15, *) {
                FormView
                    .confirmationDialog("error_occured", isPresented: $showingErrorActionSheet, actions: {
                        Button("ok", role: .cancel) {
                            showingErrorActionSheet = false
                            showingFunctionalityCheckView = true
                        }
                    }) {
                        Text(functionalityError.localizedMessage)
                    }
            } else {
                FormView
                    .actionSheet(isPresented: $showingErrorActionSheet) {
                        ActionSheet(title: Text("error_occured"), message: Text(functionalityError.localizedMessage), buttons: [.default(Text("ok"))])
                    }
            }
        }
    }
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            InnerView
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationView {
                InnerView
            }
            .navigationViewStyle(.stack)
        }
    }
    
    func handleIsEnabledBindingResult(_ result: Result<Void, Functionality.Error>) {
            switch result {
            case .success():
                break
            case .failure(let error):
                functionalityError = error
                showingErrorActionSheet = true
            }
    }
    
    func resetAllData() {
        resetAllDataOn(dataManager: dataManager, appManager: appManager)
        showingLoginView = true
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(dataManager: MockDataManager(), appManager: .init())
    }
}
