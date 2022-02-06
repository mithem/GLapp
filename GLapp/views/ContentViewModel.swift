//
//  ContentViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 20.11.21.
//

import Combine
import SwiftUI
import StoreKit

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
        appManager.selfRepair()
        appManager.reload(with: dataManager)
        applyFirstLaunchConfiguration()
        dataManager.loadData()
        NotificationManager.default.removeAllDeliveredAndAppropriate()
        handleIntent()
        if reviewRequestAppropriate(), let scene = UIApplication.shared.uiWindowScene {
            requestReview(in: scene)
        }
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
    
    private func showVersionUpdatePromoView() -> Bool {
        UserDefaults.standard.bool(for: \.showVersionUpdatePromoView)
    }
    
    func showModalSheetView() -> ModalSheetView {
        if showLoginView() {
            return .loginView
        }
        if showFunctionalityCheck() {
            return .functionalityCheckView
        }
        if showVersionUpdatePromoView() {
            return .versionUpdatePromoView
        }
        return .none
    }
    
    func tick() {
        handleIntent()
        applyFirstLaunchConfiguration()
    }
    
    func reviewRequestAppropriate() -> Bool {
        guard UserDefaults.standard.integer(for: \.launchCount) >= Constants.ReviewRequests.minimumLaunchCount  else { return false }
        let lastUpdate = UserDefaults.standard.date(for: \.lastVersionUpdateDate)
        if let lastUpdate = lastUpdate {
            guard Date.rightNow.timeIntervalSince(lastUpdate) >= Constants.ReviewRequests.minimumTimeIntervalSinceUpdate else { return false }
        }
        let lastRequest = UserDefaults.standard.date(for: \.lastReviewRequested)
        if let lastRequest = lastRequest {
            return Date.rightNow.timeIntervalSince(lastRequest) >= Constants.ReviewRequests.minimumTimeIntervalBetweenRequests
        }
        return true
    }
    
    /// Request review after waiting a few seconds.
    func requestReview(in scene: UIWindowScene) {
        DispatchQueue.init(label: Constants.Identifiers.appId + ".request_review").async {
            sleep(3)
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview(in: scene)
                UserDefaults.standard.set(date: Date.rightNow, for: \.lastReviewRequested)
            }
        }
    }
    
    enum ModalSheetView {
        case none, loginView, functionalityCheckView, versionUpdatePromoView
    }
    
    enum SubView: Int {
        case timetable = 1
        case classTestPlan = 2
        case reprPlan = 3
        case settings = 4
    }
}
