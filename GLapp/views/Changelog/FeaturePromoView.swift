//
//  FeaturePromoView.swift
//  GLapp
//
//  Created by Miguel Themann on 03.02.22.
//

import SwiftUI

struct FeaturePromoView: View {
    let promo: FeaturePromo
    var body: some View {
        HStack {
            HStack(spacing: 50) {
                HStack {
                    promo.symbol()
                        .font(.title)
                    Spacer()
                }
                .frame(width: 30)
                .padding([.leading])
                VStack(alignment: .leading) {
                    Text(NSLocalizedString(promo.titleKey))
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(NSLocalizedString(promo.descriptionKey))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.vertical)
            Spacer()
        }
        .padding(.horizontal)
    }
}

#if DEBUG
struct FeaturePromoView_Previews: PreviewProvider {
    static var previews: some View {
        VersionUpdatePromoView(appManager: .init(), dataManager: MockDataManager(), update: Changelog.versionUpdates.last(where: \.isFeatureUpdate)!)
    }
}
#endif
