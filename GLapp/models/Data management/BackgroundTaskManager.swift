//
//  BackgroundTaskManager.swift
//  BackgroundTaskManager
//
//  Created by Miguel Themann on 14.10.21.
//

import BackgroundTasks
import UIKit

final class BackgroundTaskManager {
    class func scheduleRepresentativeCheckTask() {
        let request = BGAppRefreshTaskRequest(identifier: Constants.Identifiers.backgroundCheckRepresentativePlan)
        request.earliestBeginDate = Date(timeIntervalSinceNow: Constants.checkReprPlanInBackgroundAfterMinTimeInterval)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print(error)
        }
    }
    
    class func checkForBackgroundReprPlanCheckEnabled() -> Bool {
        return UIApplication.shared.backgroundRefreshStatus != .denied
    }
    
    class func registerTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Constants.Identifiers.backgroundCheckRepresentativePlan, using: nil) { task in
            NotificationManager.default.checkRepresentativePlanAndDeliverNotification(task: task)
            scheduleRepresentativeCheckTask()
        }
    }
}
