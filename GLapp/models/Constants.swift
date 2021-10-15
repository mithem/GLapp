//
//  Constants.swift
//  Constants
//
//  Created by Miguel Themann on 08.10.21.
//

import Foundation
import SwiftUI

struct Constants {
    static let apiHostname = "https://mobil.gymnasium-lohmar.org"
    static let timeoutInterval: TimeInterval = 15
    static let checkReprPlanInBackgroundAfterMin: TimeInterval = 10 // 10 * 60
    static let checkReprPlanInBackgroundTimeIntervalTillNotificationScheduled: TimeInterval = 1
    
    struct Identifiers {
        static let appId = "com.mithem.GLapp"
        static let backgroundCheckRepresentativePlan = appId + ".backgroundCheckRepresentativePlan"
        static let newReprPlanNotification = appId + ".newRepresentativePlanNotification"
    }
}
