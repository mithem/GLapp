//
//  AppLockGateView.swift
//  GLapp
//
//  Created by Miguel Themann on 12.01.22.
//

import SwiftUI

/// Lock entire app behind this gate, if appropriate.
/// Doing this here instead of in ContentView (besides less clutter) hides special views like sheets & confirmationDialogs
struct AppLockGateView: View {
    @ObservedObject var dataManager: DataManager
    @ObservedObject var appManager: AppManager
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        Group {
            if isAppLocked() {
                AppLockedView()
            } else {
                ContentView(dataManager: dataManager, appManager: appManager)
            }
        }
        .onChange(of: scenePhase, to: .background, perform: lockApp)
    }
}

struct AppLockGateView_Previews: PreviewProvider {
    static var previews: some View {
        AppLockGateView(dataManager: MockDataManager(), appManager: .init())
    }
}
