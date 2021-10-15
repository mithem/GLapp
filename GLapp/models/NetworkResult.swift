//
//  NetworkResult.swift
//  NetworkResult
//
//  Created by Miguel Themann on 01.10.21.
//

import Foundation

enum NetworkResult<Success: Any, Failure: Error> {
    case success
    case successWithData(_ data: Success)
    case failure(_ error: Failure)
}
