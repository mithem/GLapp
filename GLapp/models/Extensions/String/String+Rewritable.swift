//
//  String+isRewrite.swift
//  GLapp
//
//  Created by Miguel Themann on 20.11.21.
//

import Foundation

extension String: Rewritable {
    var isRewrite: Bool {
        lowercased().starts(with: "nachschrift")
    }
}
