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
                        ForEach(appManager.userExperienceRelevantFunctionalities.filter {$0.isSupported == .yes}) { functionality in
                            FunctionalityInlineView(functionality: functionality, appManager: appManager, dataManager: dataManager)
                        }
                    }
                    .padding(.horizontal, 50)
                    AccentColorButton("ok") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .keyboardShortcut(.defaultAction)
                    .keyboardShortcut(.cancelAction)
                }
            }
            .onAppear {
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                appManager.reload(with: dataManager)
                giveCorrectHapticFeedback(with: generator)
            }
            .onDisappear {
                UserDefaults.standard.set(true, for: \.didShowFunctionalityCheck)
            }
            .navigationTitle("functionality_check")
            .onReceive(timer) { _ in
                appManager.reload(with: dataManager)
            }
        }
    }
    
    func giveCorrectHapticFeedback(with generator: UINotificationFeedbackGenerator) {
        if !appManager.hasLoadedAllRelevantFunctionalityStates {
            return
        }
        let disabled = appManager.hasDisabledFunctionalities()
        if disabled.critical {
            generator.notificationOccurred(.error)
        } else if disabled.optional {
            generator.notificationOccurred(.warning)
        }
        generator.notificationOccurred(.success)
    }
}

struct FunctionalityCheckView_Previews: PreviewProvider {
    static var previews: some View {
        FunctionalityCheckView(appManager: .init(), dataManager: MockDataManager())
    }
}
