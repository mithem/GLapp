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
                Toggle(appManager.classTestCalendarEvents.title, isOn: appManager.classTestCalendarEvents.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult))
            }
            Toggle(appManager.backgroundReprPlanNotifications.title, isOn: appManager.backgroundReprPlanNotifications.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult))
            Toggle(appManager.coloredInlineSubjects.title, isOn: appManager.coloredInlineSubjects.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult))
            if appManager.spotlightIntegration.isSupported.unwrapped {
                Toggle(appManager.spotlightIntegration.title, isOn: appManager.spotlightIntegration.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult))
            }
            Toggle(appManager.requireAuthentication.title, isOn: appManager.requireAuthentication.isEnabledBinding(appManager: appManager, dataManager: dataManager, setCompletion: handler.handleIsEnabledBindingResult))
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
