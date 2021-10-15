//
//  FunctionalityCheckView.swift
//  FunctionalityCheckView
//
//  Created by Miguel Themann on 15.10.21.
//

import SwiftUI

struct FunctionalityCheckView: View {
    @ObservedObject var model = FunctionalityCheckViewModel()
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        NavigationView {
            VStack(spacing: 100) {
                VStack(alignment: .leading, spacing: 50) {
                    FunctionalityInlineView(enabled: model.notificationsEnabled, title: "feature_notifications_title", description: "feature_notifications_description", callToAction: "enable") {
                        presentationMode.wrappedValue.dismiss()
                        model.enableNotifications()
                    }
                    FunctionalityInlineView(enabled: model.backgroundReprPlanCheckEnabled, title: "feature_background_repr_plan_check_title", description: "feature_background_repr_plan_check_description", callToAction: "enable") {
                        presentationMode.wrappedValue.dismiss()
                        model.enableBackgroundTasks()
                    }
                }
                .padding(.horizontal, 50)
                AccentColorButton("ok") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("functionality_check")
        }
    }
}

struct FunctionalityCheckView_Previews: PreviewProvider {
    static var previews: some View {
        FunctionalityCheckView()
    }
}
