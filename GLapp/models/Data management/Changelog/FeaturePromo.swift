//
//  FeaturePromo.swift
//  GLapp
//
//  Created by Miguel Themann on 03.02.22.
//

import Foundation
import SwiftUI

struct FeaturePromo: Identifiable {
    typealias SymbolProvider = () -> Image
    var id: String { titleKey }
    
    let titleKey: String
    let descriptionKey: String
    let symbol: SymbolProvider
}
