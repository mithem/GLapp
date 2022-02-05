//
//  VersionUpdate.swift
//  GLapp
//
//  Created by Miguel Themann on 03.02.22.
//

import Foundation
import Semver

struct VersionUpdate: Identifiable {
    var id: Semver { version }
    let version: Semver
    let new: [ChangelogItem]
    let improved: [ChangelogItem]
    let fixed: [ChangelogItem]
    let promos: [FeaturePromo]
    let note: String?
    
    var isFeatureUpdate: Bool {
        !promos.isEmpty
    }
    
    init(version: Semver, new: [ChangelogItem], improved: [ChangelogItem], fixed: [ChangelogItem], promos: [FeaturePromo], note: String? = nil) {
        self.version = version
        self.new = new
        self.improved = improved
        self.fixed = fixed
        self.promos = promos
        self.note = note
    }
    
    init?(version: String, new: [String], improved: [String], fixed: [String], promos: [FeaturePromo], note: String? = nil) {
        guard let semver = Semver(version) else { return nil}
        self.version = semver
        self.new = new.map(ChangelogItem.init)
        self.improved = improved.map(ChangelogItem.init)
        self.fixed = fixed.map(ChangelogItem.init)
        self.promos = promos
        self.note = note
    }
}
