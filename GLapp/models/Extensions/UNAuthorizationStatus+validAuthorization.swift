//
//  UNAuthorizationStatus+validAuthorization.swift
//  GLapp
//
//  Created by Miguel Themann on 24.10.21.
//

import UserNotifications

extension UNAuthorizationStatus {
    var validAuthoriatization: Bool {
        return [.authorized, .ephemeral, .provisional].contains(self)
    }
}
