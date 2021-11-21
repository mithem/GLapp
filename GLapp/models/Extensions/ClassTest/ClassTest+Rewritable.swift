//
//  ClassTest+Rewritable.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension ClassTest: Rewritable {
    var isRewrite: Bool {
        subject.isRewrite
    }
}
