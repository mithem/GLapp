//
//  GLappError.swift
//  GLappError
//
//  Created by Miguel Themann on 09.10.21.
//

import Foundation

protocol GLappError: Error {
    var localizedMessage: String { get }
}
