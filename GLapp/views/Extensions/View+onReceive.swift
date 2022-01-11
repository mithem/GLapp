//
//  View+onReceive.swift
//  GLapp
//
//  Created by Miguel Themann on 11.01.22.
//

import SwiftUI
import Combine

extension View {
    func onReceive<P>(_ publisher: P, perform action: @escaping () -> Void) -> some View where P: Publisher, P.Failure == Never {
        self
            .onReceive(publisher) { _ in
                action()
            }
    }
}
