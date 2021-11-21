//
//  String+init+Optional<CustomStringConvertible>.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import Foundation

extension String {
    init?(_ value: CustomStringConvertible?) {
        if let value = value {
            self.init(value)
        } else {
            return nil
        }
    }
}
