//
//  VersionUpdatePromoView.swift
//  GLapp
//
//  Created by Miguel Themann on 03.02.22.
//

import SwiftUI

struct VersionUpdatePromoView: View {
    @ObservedObject private var model: VersionUpdatePromoViewModel
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                    .frame(height: 50)
                Text("whats_new")
                    .font(.title)
                Text(NSLocalizedString("version_prefix") + model.update.version.description)
                    .foregroundColor(.secondary)
                Spacer()
                ForEach(model.update.promos) { promo in
                    FeaturePromoView(promo: promo)
                }
                if let note = model.update.note {
                    ForEach(note.split(separator: "\n").map(String.init)) { note in
                        Spacer()
                        Text(NSLocalizedString(note))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                        .foregroundColor(.secondary)
                }
                if model.showCloseButton {
                    AccentColorButton("close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .onDisappear {
                UserDefaults.standard.set(Changelog.currentVersion.description, for: \.lastLaunchedVersion) // As this is gonna be shown on each (feature) version launch (bug fixes & improvements of intermediate updates should therefore also be contained in the update (but not shown on-screen, as there aren't any promos, then))
                UserDefaults.standard.set(false, for: \.showVersionUpdatePromoView)
            }
        }
    }
    
    init(appManager: AppManager, dataManager: DataManager, update: VersionUpdate? = nil, showCloseButton: Bool = false) {
        self.model = .init(appManager: appManager, dataManager: dataManager, update: update, showCloseButton: showCloseButton)
    }
}

#if DEBUG
struct VersionUpdatePromoView_Previews: PreviewProvider {
    static var previews: some View {
        VersionUpdatePromoView(appManager: .init(), dataManager: MockDataManager(), update: Changelog.versionUpdates.first(where: \.isFeatureUpdate)!)
        VersionUpdatePromoView(appManager: .init(), dataManager: MockDataManager(), update: Changelog.versionUpdates.first(where: \.isFeatureUpdate)!, showCloseButton: true)
    }
}
#endif
