//
//  ChangelogView.swift
//  GLapp
//
//  Created by Miguel Themann on 03.02.22.
//

import SwiftUI

struct ChangelogView: View {
    @ObservedObject private var model: ChangelogViewModel
    var body: some View {
        ScrollView {
            ForEach(Changelog.versionUpdates) { update in
                VersionUpdateView(appManager: model.appManager, dataManager: model.dataManager, update: update)
            }
        }
        .navigationTitle("changelog")
    }
    
    init(appManager: AppManager, dataManager: DataManager) {
        model = .init(appManager: appManager, dataManager: dataManager)
    }
}

#if DEBUG
struct ChangelogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangelogView(appManager: .init(), dataManager: MockDataManager())
        }
    }
}
#endif
