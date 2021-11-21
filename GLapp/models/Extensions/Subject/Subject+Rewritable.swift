//
//  Subject+Rewritable.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension Subject: Rewritable {
    var isRewrite: Bool {
        className.isRewrite
    }
}
