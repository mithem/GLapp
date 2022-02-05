//
//  ChangelogItem.swift
//  GLapp
//
//  Created by Miguel Themann on 03.02.22.
//

import Foundation

struct ChangelogItem: Identifiable {
    var id: String { title }
    let title: String
}
