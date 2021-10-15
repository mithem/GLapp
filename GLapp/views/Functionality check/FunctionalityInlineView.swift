//
//  FunctionalityInlineView.swift
//  FunctionalityInlineView
//
//  Created by Miguel Themann on 15.10.21.
//

import SwiftUI

struct FunctionalityInlineView: View {
    let enabled: Bool
    let title: String
    let description: String
    let callToAction: LocalizedStringKey
    let callback: () -> Void
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(imageColor)
                .font(.title)
            VStack(alignment: .leading) {
                Text(NSLocalizedString(title, comment: title))
                    .font(.title3)
                Text(NSLocalizedString(description, comment: description))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            if !enabled {
                Spacer()
                AccentColorButton(callToAction, action: callback)
            }
        }
    }
    
    var imageName: String {
        switch enabled {
        case true:
            return "checkmark.diamond"
        case false:
            return "xmark.diamond"
        }
    }
    
    var imageColor: Color {
        switch enabled {
        case true:
            return .green
        case false:
            return .red
        }
    }
    
    init(enabled: Bool, title: String, description: String, callToAction: LocalizedStringKey, callback: @escaping () -> Void) {
        self.enabled = enabled
        self.title = title
        self.description = description
        self.callToAction = callToAction
        self.callback = callback
    }
}

struct FunctionalityInlineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FunctionalityInlineView(enabled: true, title: "Notifications", description: "Receive notifications for reprPlan updates.", callToAction: "enable") {
                print("Tapped to enable notifications.")
            }
            FunctionalityInlineView(enabled: false, title: "Background reprPlan check", description: "Check the reprPlan in the background. Requires notifications.", callToAction: "enable") {
                print("tapped to enable background operation.")
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
