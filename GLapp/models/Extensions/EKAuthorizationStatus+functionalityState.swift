//
//  EKAuthorizationStatus+functionalityState.swift
//  GLapp
//
//  Created by Miguel Themann on 05.11.21.
//

import EventKit

extension EKAuthorizationStatus {
    var functionalityState: Functionality.State {
        switch self {
        case .notDetermined:
            return .unknown
        case .restricted, .denied:
            return .no
        case .authorized:
            return .yes
        @unknown default:
            return .unknown
        }
    }
}
