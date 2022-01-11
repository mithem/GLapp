//
//  AppLockedView.swift
//  GLapp
//
//  Created by Miguel Themann on 11.01.22.
//

import SwiftUI
import LocalAuthentication

struct AppLockedView: View {
    @ObservedObject var model: AppLockedViewModel
    var body: some View {
        VStack {
            EmptyContentView(image: model.emptyViewIcon, text: "app_locked")
            AccentColorButton("unlock") {
                unlock()
            }
            .disabled(model.unlocking)
        }
            .onAppear(perform: unlock)
    }
    
    init() {
        model = .init()
    }
    
    func unlock() {
        if isAppLocked() {
            model.unlock()
        }
    }
}

struct AppLockedView_Previews: PreviewProvider {
    static var previews: some View {
        AppLockedView()
    }
}
