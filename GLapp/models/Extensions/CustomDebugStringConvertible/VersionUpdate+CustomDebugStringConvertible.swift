//
//  VersionUpdate+CustomDebugStringConvertible.swift
//  GLapp
//
//  Created by Miguel Themann on 05.02.22.
//

import Foundation

#if DEBUG
extension VersionUpdate: CustomDebugStringConvertible {
    var debugDescription: String {
        "VersionUpdate(version: \(version), new: \(new), improved: \(improved), fixed: \(fixed), promos: \(promos))"
    }
}
#endif
