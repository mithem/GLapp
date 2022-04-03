//
//  SettingsView.swift
//  SettingsView
//
//  Created by Miguel Themann on 08.10.21.
//

import SwiftUI

struct SettingsView: View, SettingsViewIsEnabledBindingResultHandling {
    @State private var showingLoginView = false
    @State private var showingFunctionalityCheckView = false
    @State private var functionalityError = Functionality.Error.notImplemented
    @ObservedObject var dataManager: DataManager
    @ObservedObject var appManager: AppManager
    @ObservedObject var confirmationDialogProvider: ConfirmationDialogProvider
    @AppStorage(UserDefaultsKeys().launchCount) var launchCount = 0
    var FormView: some View {
        Form {
            Section {
                NavigationLink("general") {
                    GeneralSettings(dataManager: dataManager, appManager: appManager, handler: self)
                }
                if dataManager.tasks.getClassTestPlan.error != .classTestPlanNotSupported {
                    NavigationLink("class_test_reminders") {
                        ClassTestReminderSettings(dataManager: dataManager, appManager: appManager, handler: self)
                    }
                }
                NavigationLink("advanced_settings") {
                    AdvancedSettingsView(appManager: appManager, dataManager: dataManager)
                }
            }
            Section {
                NavigationLink(destination: {
                    ChangelogView(appManager: appManager, dataManager: dataManager)
                }) {
                    HStack {
                        Text("changelog")
                        Spacer()
                        Text(NSLocalizedString("version_prefix") + Changelog.currentVersion.description)
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .monospaced))
                    }
                }
                Button("check_for_functionality") {
                    showingFunctionalityCheckView = true
                }
                .sheet(isPresented: $showingFunctionalityCheckView) {
                    FunctionalityCheckView(appManager: appManager, dataManager: dataManager)
                }
                Link("Review", destination: Constants.appStoreWriteReviewURL)
                Link("feedback", destination: Constants.mailToURL)
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
                Button("reset_preferences") {
                    appManager.settingsStore.reset(withHapticFeedback: true)
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
                        dataManager.reset()
                        resetLoginInfo()
                    }
                }
            }
            if Changelog.currentVersion.isPrerelease {
                Text(NSLocalizedString("prerelease_version_exl_mark") + " (\(Changelog.currentVersion))")
                    .foregroundColor(.secondary)
            }
            #if DEBUG
            Button("dev_reset") {
                devReset(appManager: appManager, dataManager: dataManager)
            }
            Stepper(settingsValue: \.launchCount) {
                "Launch count: \(launchCount)"
            }
            #endif
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
        self.confirmationDialogProvider = .init(title: "error_occured", body: "unknown_error")
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(dataManager: MockDataManager(), appManager: .init())
    }
}
#endif
