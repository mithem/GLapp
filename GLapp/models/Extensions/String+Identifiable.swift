//
//  String+Identifiable.swift
//  String+Identifiable
//
//  Created by Miguel Themann on 10.10.21.
//

import Foundation

extension String: Identifiable {
    public var id: String { self }
}
