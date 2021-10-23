//
//  FunctionalityCheckView.swift
//  FunctionalityCheckView
//
//  Created by Miguel Themann on 15.10.21.
//

import SwiftUI

struct FunctionalityCheckView: View {
    @ObservedObject var appManager: AppManager
    @ObservedObject var dataManager: DataManager
    @Environment(\.presentationMode) private var presentationMode
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 100) {
                    VStack(alignment: .leading, spacing: 50) {
                        ForEach([appManager.notifications, appManager.backgroundRefresh, appManager.backgroundReprPlanNotifications, appManager.classTestReminders]) { functionality in
                            FunctionalityInlineView(functionality: functionality, appManager: appManager, dataManager: dataManager)
                        }
                    }
                    .padding(.horizontal, 50)
                    AccentColorButton("ok") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                appManager.reload(with: dataManager)
            }
            .navigationTitle("functionality_check")
            .onReceive(timer) { _ in
                appManager.reload(with: dataManager)
            }
        }
    }
}

struct FunctionalityCheckView_Previews: PreviewProvider {
    static var previews: some View {
        FunctionalityCheckView(appManager: .init(), dataManager: MockDataManager())
    }
}
