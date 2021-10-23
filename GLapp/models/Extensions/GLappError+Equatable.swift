//
//  GLappError+Equatable.swift
//  GLappError+Equatable
//
//  Created by Miguel Themann on 20.10.21.
//

import Foundation


extension GLappError: Equatable {
    static func == (lhs: GLappError, rhs: GLappError) -> Bool {
        lhs.localizedMessage == rhs.localizedMessage
    }
}
