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
    @Published var modalSheetView: ModalSheetView
    @Published var showingModalSheetView: Bool // system may set this to false before showing sheet, so information would be lost when setting modalSheetView = .none
    
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    var currentView: SubView {
        get {
            .init(rawValue: UserDefaults.standard.integer(forKey: UserDefaultsKeys.lastTabView)) ?? .timetable
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKeys.lastTabView)
        }
    }
    
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
        modalSheetView = .none
        showingModalSheetView = false
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
            currentView = .timetable
        case .showClassTestPlan:
            if appManager.classTestPlan.isEnabled.unwrapped {
                currentView = .classTestPlan
            } else {
                currentView = .timetable
            }
        case .showRepresentativePlan:
            currentView = .reprPlan
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
            modalSheetView = .loginView
            showingModalSheetView = true
        }
    }
    
    func applyFirstLaunchedConfiguration() {
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.launchCount)
        switch count {
        case 1:
            NotificationManager.default.requestNotificationAuthorization()
        case 2:
            modalSheetView = .functionalityCheckView
            showingModalSheetView = true
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
