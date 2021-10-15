//
//  BackgroundTaskManager.swift
//  BackgroundTaskManager
//
//  Created by Miguel Themann on 14.10.21.
//

import BackgroundTasks
import UIKit

class BackgroundTaskManager {
    static func registerRepresentativeCheckTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Constants.Identifiers.backgroundCheckRepresentativePlan, using: nil) { task in
            NotificationManager.checkRepresentativePlanAndDeliverNotification()
        }
        let request = BGAppRefreshTaskRequest(identifier: Constants.Identifiers.backgroundCheckRepresentativePlan)
        request.earliestBeginDate = Date(timeIntervalSinceNow: Constants.checkReprPlanInBackgroundAfterMin)
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Constants.Identifiers.backgroundCheckRepresentativePlan)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            guard let error = error as? BGTaskScheduler.Error else { return }
            print(error)
            print(error._nsError)
            print(error.localizedDescription)
        }
    }
    
    static func checkForBackgroundReprPlanCheckEnabled() -> Bool {
        return UIApplication.shared.backgroundRefreshStatus != .denied
    }
}
