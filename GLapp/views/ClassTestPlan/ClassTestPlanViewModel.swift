//
//  ClassTestPlanViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 16.11.21.
//

import Foundation
import Combine

@MainActor final class ClassTestPlanViewModel: ObservableObject {
    @Published var appManager: AppManager
    @Published var dataManager: DataManager
    @Published var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private var startDate: Date
    private var didDonateIntent: Bool
    
    init(appManager: AppManager, dataManager: DataManager) {
        self.appManager = appManager
        self.dataManager = dataManager
        timer = Timer.publish(every: Constants.timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated, tolerance: nil, on: .current, in: .common).autoconnect()
        startDate = .rightNow
        didDonateIntent = false
    }
    
    ///Donate intent if appropriate.
    ///
    /// Donate if:
    /// - user has spent a reasonable amount of time on screen
    /// - did not already donate an intent
    /// - Parameter force: donate (if haven't already) even if the 'reasonable' amount of time on screen hasn't passed yet. Useful for e.g. refresh actions.
    func donateIntent(force: Bool = false) {
        if (startDate.distance(to: .rightNow) >= Constants.timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated || force) && !didDonateIntent {
            IntentToHandle.showClassTestPlan.donate()
            didDonateIntent = true
        }
    }
    
    func reload() {
        dataManager.loadData(withHapticFeedBack: true) // reprPlanView & timetable do the same, therefore don't introduce unexpected behavior
        donateIntent(force: true)
    }
}
