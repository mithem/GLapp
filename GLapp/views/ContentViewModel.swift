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
    @Published var showingConfirmationDialog: Bool
    
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @AppStorage(UserDefaultsKeys().didUnlockInCurrentSession) var didUnlockInCurrentSession = false
    
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
        timer = Timer.publish(every: 1, tolerance: nil, on: .current, in: .common).autoconnect() // I know that's less elegant and efficient, but how else would I do that?
        showingConfirmationDialog = false
    }
    
    func onAppear() {
        appManager.reload(with: dataManager)
        applyFirstLaunchConfiguration()
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
        let intentToHandle = UserDefaults.standard.string(for: \.intentToHandle)
        let intent = IntentToHandle(rawValue: intentToHandle ?? "")
        switch intent {
        case .showTimetable:
            UserDefaults.standard.set(0, for: \.lastTabView)
        case .showClassTestPlan:
            if appManager.classTestPlan.isEnabled.unwrapped {
                UserDefaults.standard.set(1, for: \.lastTabView)
            } else {
                UserDefaults.standard.set(0, for: \.lastTabView)
            }
        case .showRepresentativePlan:
            UserDefaults.standard.set(2, for: \.lastTabView)
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
        UserDefaults.standard.setNil(for: \.intentToHandle)
    }
    
    func applyFirstLaunchConfiguration() {
        let count = UserDefaults.standard.integer(for: \.launchCount)
        switch count {
        case 1:
            NotificationManager.default.requestNotificationAuthorization()
        default:
            break
        }
    }
    
    private func showLoginView() -> Bool {
        if !isLoggedIn() && !appManager.demoMode.isEnabled.unwrapped {
            return true
        }
        return false
    }
    
    private func showFunctionalityCheck() -> Bool {
        if UserDefaults.standard.bool(for: \.didShowFunctionalityCheck) { return false }
        return UserDefaults.standard.integer(for: \.launchCount) == 2
    }
    
    func showModalSheetView() -> ModalSheetView {
        if showLoginView() {
            return .loginView
        }
        return showFunctionalityCheck() ? .functionalityCheckView : .none
    }
    
    func tick() {
        handleIntent()
        applyFirstLaunchConfiguration()
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
