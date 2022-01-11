//
//  View+onChange.swift
//  GLapp
//
//  Created by Miguel Themann on 11.01.22.
//

import SwiftUI

extension View {
    func onChange<V>(of value: V, perform action: @escaping () -> Void) -> some View where V: Equatable {
        self
            .onChange(of: value) { _ in
                action()
            }
    }
    
    func onChange<V>(of value: V, to: V, perform action: @escaping (V) -> Void) -> some View where V: Equatable {
        self
            .onChange(of: value) { newValue in
                if newValue == to {
                    action(newValue)
                }
            }
    }
    
    func onChange<V>(of value: V, to: V, perform action: @escaping () -> Void) -> some View where V: Equatable {
        self
            .onChange(of: value) { newValue in
                if newValue == to {
                    action()
                }
            }
    }
}
