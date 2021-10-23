//
//  FSError.swift
//  FSError
//
//  Created by Miguel Themann on 18.10.21.
//

import Foundation

enum FSError: Error {
    case noURL
    
    var localizedMessage: String {
        switch self {
        case .noURL:
            return NSLocalizedString("fs_error_no_url")
        }
    }
}
