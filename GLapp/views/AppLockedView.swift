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
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        VStack {
            EmptyContentView(image: model.emptyViewIcon, text: "app_locked")
            AccentColorButton("unlock") {
                unlock()
            }
            .disabled(model.unlocking)
        }
            .onAppear(perform: unlock)
            .onChange(of: scenePhase, to: .active) {
                unlock()
                model.enterForeground()
            }
    }
    
    init() {
        model = .init()
    }
    
    func unlock() {
        model.unlock()
    }
}

struct AppLockedView_Previews: PreviewProvider {
    static var previews: some View {
        AppLockedView()
    }
}
