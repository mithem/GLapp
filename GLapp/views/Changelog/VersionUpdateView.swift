//
//  VersionUpdateView.swift
//  GLapp
//
//  Created by Miguel Themann on 03.02.22.
//

import SwiftUI

extension Color {
    static func background(colorScheme: ColorScheme) -> Self {
        switch colorScheme {
        case .light:
            return .init(white: 0.95)
        case .dark:
            return .init(white: 0.1)
        @unknown default:
            return .gray
        }
    }
}

struct VersionUpdateView: View {
    @ObservedObject private var model: VersionUpdateViewModel
    @Environment(\.colorScheme) private var colorScheme
    static let spacerHeight: CGFloat = 25
    var body: some View {
        NavigationLink(isActive: $model.showingPromoView, destination: {
            VersionUpdatePromoView(appManager: model.appManager, dataManager: model.dataManager, update: model.update)
        }) {
            EmptyView()
        }
        VStack(alignment: .leading) {
            Text(NSLocalizedString("version_prefix") + model.update.version.description)
                .font(.title2)
                .padding(.leading)
                .border(width: 5, edges: [.leading], color: model.update.borderColor)
            if !model.update.new.isEmpty {
                Spacer()
                    .frame(height: Self.spacerHeight)
                Text("new")
                    .font(.headline)
                    .foregroundColor(.green)
                ForEach(model.update.new) { new in
                    ChangelogItemView(item: new)
                }
            }
            if !model.update.improved.isEmpty {
                Spacer()
                    .frame(height: Self.spacerHeight)
                Text("improved")
                    .font(.headline)
                    .foregroundColor(.blue)
                ForEach(model.update.improved) { improved in
                    ChangelogItemView(item: improved)
                }
            }
            if !model.update.fixed.isEmpty {
                Spacer()
                    .frame(height: Self.spacerHeight)
                Text("fixed")
                    .font(.headline)
                    .foregroundColor(.red)
                ForEach(model.update.fixed) { fixed in
                    ChangelogItemView(item: fixed)
                }
            }
            if let note = model.update.note {
                Spacer()
                    .frame(height: Self.spacerHeight)
                Text("notes_attention")
                    .font(.headline)
                ForEach(note.split(separator: "\n").map(String.init)) { note in
                    ChangelogItemView(item: .init(title: note))
                }
            }
            if model.update.isFeatureUpdate {
                Spacer()
                    .frame(height: 10)
                HStack {
                    Spacer()
                    Label(title: {
                        Text("show_feature_promo")
                            .foregroundColor(.green)
                    }, icon: {
                        Image(systemName: "sparkles.square.filled.on.square")
                            .foregroundColor(.green)
                    })
                        .padding(5)
                        .hoverEffect()
                }
            }
            HStack { // grow horizontally
                Spacer()
            }
        }
        .padding()
        .background(Color.background(colorScheme: colorScheme))
        .cornerRadius(15)
        .onTapGesture {
            if model.update.isFeatureUpdate {
                model.showingPromoView = true
            }
        }
        .padding()
    }
    
    init(appManager: AppManager, dataManager: DataManager, update: VersionUpdate) {
        model = .init(appManager: appManager, dataManager: dataManager, update: update)
    }
}

#if DEBUG
struct VersionUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        VersionUpdateView(appManager: .init(), dataManager: MockDataManager(), update: Changelog.versionUpdates.first(where: \.isFeatureUpdate)!)
            .previewLayout(.sizeThatFits)
    }
}
#endif
