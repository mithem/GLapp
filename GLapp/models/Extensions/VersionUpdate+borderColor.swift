//
//  VersionUpdate+borderColor.swift
//  GLapp
//
//  Created by Miguel Themann on 03.02.22.
//

import SwiftUI

extension VersionUpdate {
    var borderColor: Color {
        if #available(iOS 15, *), isFeatureUpdate {
            return .indigo
        }
        if !new.isEmpty {
            return .green
        }
        if !improved.isEmpty {
            return .blue
        }
        if !fixed.isEmpty {
            return .red
        }
        return .secondary
    }
}
