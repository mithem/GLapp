//
//  UIApplication+uiWindowScene.swift
//  GLapp
//
//  Created by Miguel Themann on 28.03.22.
//

import UIKit

extension UIApplication {
    var uiWindowScene: UIWindowScene? {
        return connectedScenes
            .filter {[.foregroundActive, .foregroundInactive].contains($0.activationState) }
            .first(where: { $0 is UIWindowScene })
            .flatMap {$0 as? UIWindowScene}
    }
}

