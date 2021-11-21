//
//  Rewritable.swift
//  GLapp
//
//  Created by Miguel Themann on 20.11.21.
//

import Foundation

/// Indicating an object representing a real-life class test in some way that may be rewritten (Nachschrift)
protocol Rewritable {
    
    /// Whether the object is a rewrite (Nachschrift).
    var isRewrite: Bool { get }
}
