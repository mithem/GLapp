//
//  GeneralSettings.swift
//  GLapp
//
//  Created by Miguel Themann on 18.12.21.
//

import SwiftUI

struct GeneralSettings: View {
    @ObservedObject var dataManager: DataManager
    @ObservedObject var appManager: AppManager
    let handler: SettingsViewIsEnabledBindingResultHandling
    let timer = Timer.publish(every: 1, tolerance: nil, on: .current, in: .common).autoconnect()
    var body: some View {
        Form {
            if dataManager.tasks.getClassTestPlan.error != .classTestPlanNotSupported {
                Toggle(settingsValue: \.classTestCalendarEvents, appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult)
            }
            Toggle(settingsValue: \.backgroundReprPlanNotifications, appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult)
            Toggle(settingsValue: \.coloredInlineSubjects, appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult)
            if appManager.spotlightIntegration.isSupported.unwrapped {
                Toggle(settingsValue: \.spotlightIntegration, appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult)
            }
            Toggle(settingsValue: \.requireAuthentication, appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult)
        }
        .onReceive(timer) {
            appManager.reload(with: dataManager)
        }
        .navigationTitle("general")
    }
}

struct GeneralSettings_Previews: PreviewProvider, SettingsViewIsEnabledBindingResultHandling {
    static var previews: some View {
        GeneralSettings(dataManager: MockDataManager(), appManager: .init(), handler: self as! SettingsViewIsEnabledBindingResultHandling)
    }
    
    func handleIsEnabledBindingResult(_ result: Result<Void, Functionality.Error>) {}
}
