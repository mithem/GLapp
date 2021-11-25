//
//  ContentViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 20.11.21.
//

import Combine
import SwiftUI

final class ContentViewModel: ObservableObject, BindingAttributeRepresentable {
    @Published var appManager: AppManager
    @Published var dataManager: DataManager
    @Published var showLoginView: Bool
    @Published var showFunctionalityCheckView: Bool
    
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    var reprPlanTabItemIcon: String {
        if #available(iOS 15, *) {
            if dataManager.representativePlan?.isEmpty == false {
                return "clock.badge.exclamationmark"
            }
        }
        return "clock"
    }
    
    init(appManager: AppManager, dataManager: DataManager) {
        self.appManager = appManager
        self.dataManager = dataManager
        showLoginView = false
        showFunctionalityCheckView = false
        timer = Timer.publish(every: 1, tolerance: nil, on: .current, in: .common).autoconnect() // I know that's less elegant and efficient, but how else would I do that?
    }
    
    func onAppear() {
        appManager.reload(with: dataManager)
        checkForNeedingToShowLoginView()
        applyFirstLaunchedConfiguration()
        dataManager.loadData()
        NotificationManager.default.removeAllDeliveredAndAppropriate()
        handleIntent()
    }
    
    func onDisappear() {
        dataManager.saveLocalData()
        appManager.classTestReminders.scheduleClassTestRemindersIfAppropriate(with: dataManager)
    }
    
    func handleIntent() {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return } // iPadOS UI doesn't support that
        let intentToHandle = UserDefaults.standard.string(forKey: UserDefaultsKeys.intentToHandle)
        let intent = IntentToHandle(rawValue: intentToHandle ?? "")
        switch intent {
        case .showTimetable:
            UserDefaults.standard.set(0, forKey: UserDefaultsKeys.lastTabView)
        case .showClassTestPlan:
            if appManager.classTestPlan.isEnabled.unwrapped {
                UserDefaults.standard.set(1, forKey: UserDefaultsKeys.lastTabView)
            } else {
                UserDefaults.standard.set(0, forKey: UserDefaultsKeys.lastTabView)
            }
        case .showRepresentativePlan:
            UserDefaults.standard.set(2, forKey: UserDefaultsKeys.lastTabView)
        case .unknown(identifier: let identifier):
            let found = dataManager.findIntent(with: identifier)
            if let found = found {
                found.save()
                handleIntent()
            }
            return // same as below
        case .none:
            return // may be executed before DataManager has loaded data, so intents may not be dealt with
        }
        UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.intentToHandle)
    }
    
    func checkForNeedingToShowLoginView() {
        if !isLoggedIn() && appManager.demoMode.isEnabled.unwrapped {
            showLoginView = true
        }
    }
    
    func applyFirstLaunchedConfiguration() {
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.launchCount)
        switch count {
        case 1:
            NotificationManager.default.requestNotificationAuthorization()
        case 2:
            showFunctionalityCheckView = true
        default:
            break
        }
    }
    
    enum ModalSheetView {
        case none, loginView, functionalityCheckView
    }
    
    enum SubView: Int {
        case timetable = 1
        case classTestPlan = 2
        case reprPlan = 3
        case settings = 4
    }
}