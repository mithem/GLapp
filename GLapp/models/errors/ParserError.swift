//
//  ParserError.swift
//  ParserError
//
//  Created by Miguel Themann on 09.10.21.
//

import Foundation

enum ParserError: GLappError {
    case noRootElement
    case invalidRootElement
    case noTimestamp
    case invalidTimestamp
    case other(_ message: String)
    
    var localizedMessage: String {
        switch self {
        case .noRootElement:
            return NSLocalizedString("no_xml_root_element", comment: "no_xml_root_element")
        case .invalidRootElement:
            return NSLocalizedString("invalid_xml_root_element", comment: "invalid_xml_root_element")
        case .noTimestamp:
            return NSLocalizedString("no_timestamp", comment: "no_timestamp")
        case .invalidTimestamp:
            return NSLocalizedString("invalid_timestamp", comment: "invalid_timestamp")
        case .other(let msg):
            return NSLocalizedString(msg, comment: msg)
        }
    }
}
