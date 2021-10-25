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
    var InnerView: some View {
        Form {
            Section {
                Button("check_for_functionality") {
                    showingFunctionalityCheckView = true
                }
                .sheet(isPresented: $showingFunctionalityCheckView) {
                    FunctionalityCheckView(appManager: appManager, dataManager: dataManager)
                }
                Toggle("auto_remind_before_class_tests", isOn: appManager.classTestReminders.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handleIsEnabledBindingResult))
                    .disabled(appManager.classTestReminders.isSupported != .yes)
                Stepper(NSLocalizedString("remind_n_days_before_class_tests_colon") + String(remindNDaysBeforeClassTests), value: $remindNDaysBeforeClassTests, in: 1...31)
                    .disabled(appManager.classTestReminders.isSupported != .yes)
                Toggle("feature_background_repr_plan_notifications_title", isOn: appManager.backgroundReprPlanNotifications.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handleIsEnabledBindingResult))
                    .disabled(appManager.backgroundReprPlanNotifications.isSupported != .yes)
                Link("feedback", destination: Constants.mailToURL)
            }
            Section {
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
            if appManager.demoMode.isEnabled == .yes {
                Section {
                    Button("demo_mode_active") {
                        try? appManager.demoMode.disable(with: appManager, dataManager: dataManager)
                    }
                }
            }
        }
        .onAppear {
            appManager.reload(with: dataManager)
        }
        .navigationTitle("settings")
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
        dataManager.reset()
        NotificationManager.default.reset()
        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.launchCount)
        appManager.reload(with: dataManager)
        resetLoginInfo()
        resetOnboarding()
        showingLoginView = true
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(dataManager: MockDataManager(), appManager: .init())
    }
}
