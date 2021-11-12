//
//  Array+Copying.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

extension Array: Copying where Element: Copying {
    func copy() -> [Element] {
        map {$0.copy()}
    }
}
