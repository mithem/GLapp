//
//  GLappError.swift
//  GLappError
//
//  Created by Miguel Themann on 09.10.21.
//

import Foundation

enum GLappError: Error {
    
    case networkError(_ error: NetworkError)
    case parserError(_ error: ParserError)
    case fsError(_ error: FSError)
    /// Not supported by the school (e.g. Unter-/Mittelstufe)
    case classTestPlanNotSupported
    /// Error occuring when en- or decoding a color (e.g. `UIColor`, `CodableColor`, `SwiftUI.Color`)
    case colorCodingError
    
    var localizedMessage: String {
        switch self {
        case .networkError(let error):
            return error.localizedMessage
        case .parserError(let error):
            return error.localizedMessage
        case .fsError(let error):
            return error.localizedMessage
        case .classTestPlanNotSupported:
            return NSLocalizedString("class_test_plan_not_supported")
        case .colorCodingError:
            return NSLocalizedString("color_coding_error")
        }
    }
}
