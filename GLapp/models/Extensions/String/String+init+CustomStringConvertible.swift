//
//  String+init.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension String {
    init(_ value: CustomStringConvertible) {
        self = value.description
    }
}
