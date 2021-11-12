//
//  Copying.swift
//  GLapp
//
//  Created by Miguel Themann on 12.11.21.
//

import Foundation

/// Like `NSCopying`, but with type safety
protocol Copying {
    func copy() -> Self
}
