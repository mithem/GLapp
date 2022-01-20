//
//  String+trimmed.swift
//  GLapp
//
//  Created by Miguel Themann on 19.01.22.
//

import Foundation

extension String {
    func trimmed() -> Self {
        trimmingCharacters(in: .whitespaces)
    }
}
