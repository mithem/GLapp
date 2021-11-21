//
//  ClassTest+CSIndexable.swift
//  GLapp
//
//  Created by Miguel Themann on 21.11.21.
//

import CoreSpotlight

extension ClassTest: CSIndexable {
    var indexItemTitle: String {
        title + " " + NSLocalizedString("class_test_mid_sentence")
    }
    
    var contentDescription: String? {
        GLDateFormatter.dateOnlyFormatter.string(from: startDate ?? classTestDate)
    }
    
    var keywords: [String] {
        ["class_test"]
    }
    
    var rankingHint: Double? { nil } // override `relevance` implied by conforming to DeliverableByNotification, giving .nan, therefore not appearing in search results at all
}
