//
//  Color+init.swift
//  GLapp
//
//  Created by Miguel Themann on 26.11.21.
//

import SwiftUI

extension Color {
    init(_ color: CodableColor) {
        self.init(color.color)
    }
}
