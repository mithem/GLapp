//
//  RepresentativePlanViewModel.swift
//  GLapp
//
//  Created by Miguel Themann on 15.11.21.
//

import Foundation
import Combine

@MainActor final class RepresentativePlanViewModel: ObservableObject {
    @Published var appManager: AppManager
    @Published var dataManager: DataManager
    @Published var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private var startDate: Date
    private var didDonateIntent: Bool
    
    init(appManager: AppManager, dataManager: DataManager) {
        self.appManager = appManager
        self.dataManager = dataManager
        self.timer = Timer.publish(every: Constants.timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated, tolerance: nil, on: .current, in: .common).autoconnect()
        self.startDate = .rightNow
        self.didDonateIntent = false
    }
    
    var emptyViewIcon: String {
        if #available(iOS 15, *) {
            return "circle.slash"
        } else {
            return "slash.circle"
        }
    }
    
    ///Donate intent if appropriate.
    ///
    /// Donate if:
    /// - user has spent a reasonable amount of time on screen
    /// - did not already donate an intent
    /// - Parameter force: donate (if haven't already) even if the 'reasonable' amount of time on screen hasn't passed yet. Useful for e.g. refresh actions.
    func donateIntent(force: Bool = false) {
        if (startDate.distance(to: .rightNow) >= Constants.timeIntervalRequiringUserActivityUntilNSUserActivityIsDonated || force) && !didDonateIntent {
            IntentToHandle.showRepresentativePlan.donate()
            didDonateIntent = true
        }
    }
    
    func reload() {
        dataManager.loadData(withHapticFeedBack: true) // so you can reload class test plan even when it's not available (empty) yet
        donateIntent(force: true)
    }
}
