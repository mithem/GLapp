//
//  BindingAttributeRepresentable.swift
//  GLapp
//
//  Created by Miguel Themann on 20.11.21.
//

import SwiftUI

protocol BindingAttributeRepresentable {
    func binding<ContentType>(for path: ReferenceWritableKeyPath<Self, ContentType>) -> Binding<ContentType>
}

extension BindingAttributeRepresentable {
    func binding<ContentType>(for path: ReferenceWritableKeyPath<Self, ContentType>) -> Binding<ContentType> {
        .init(get: {
            self[keyPath: path]
        }, set: { newValue in
            self[keyPath: path] = newValue
        })
    }
}
