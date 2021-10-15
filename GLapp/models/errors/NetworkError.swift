//
//  NetworkError.swift
//  NetworkError
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

enum NetworkError: GLappError {
    case notAuthorized
    case noData
    case badRequest
    case mobileKeyNotConfigured
    case invalidResponse
    case other(_ error: Error)
    
    var localizedMessage: String {
        switch self {
        case .notAuthorized:
            return NSLocalizedString("not_authorized", comment: "not_authorized")
        case .noData:
            return NSLocalizedString("no_data", comment: "no_data")
        case .badRequest:
            return NSLocalizedString("bad_request", comment: "bad_request")
        case .mobileKeyNotConfigured:
            return NSLocalizedString("mobile_key_not_configured", comment: "mobile_key_not_configured")
        case .invalidResponse:
            return NSLocalizedString("invalid_response", comment: "invalid_response")
        case .other(let error):
            return error.localizedDescription
        }
    }
    
    var localizedDescription: String { localizedMessage }
}
