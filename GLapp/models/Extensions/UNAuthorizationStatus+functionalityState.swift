//
//  UNAuthorizationStatus+functionalityState.swift
//  GLapp
//
//  Created by Miguel Themann on 05.11.21.
//

import UserNotifications

extension UNAuthorizationStatus {
    var functionalityState: Functionality.State {
        switch self {
        case .notDetermined:
            return .unknown
        case .denied:
            return .no
        case .authorized, .provisional, .ephemeral:
            return .yes
        @unknown default:
            return .unknown
        }
    }
}
