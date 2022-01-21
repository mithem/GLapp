//
//  Collection+compactMap.swift
//  GLapp
//
//  Created by Miguel Themann on 21.01.22.
//

import Foundation

extension Array {
    /// Remove all nil values.
    func compactMap<ElementOfResult>() -> [ElementOfResult] where Element == ElementOfResult? {
        let block: ((Element) -> ElementOfResult?) = { opt in
            return opt
        }
        return compactMap(block)
    }
}
