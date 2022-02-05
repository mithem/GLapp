//
//  ChangelogItem+CustomDebugStringConvertible.swift
//  GLapp
//
//  Created by Miguel Themann on 05.02.22.
//

import Foundation

#if DEBUG
extension ChangelogItem: CustomDebugStringConvertible {
    var debugDescription: String { title }
}
#endif
