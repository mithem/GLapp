//
//  ChangelogItemView.swift
//  GLapp
//
//  Created by Miguel Themann on 03.02.22.
//

import SwiftUI

struct ChangelogItemView: View {
    let item: ChangelogItem
    var body: some View {
        Text("• " + NSLocalizedString(item.title))
    }
}

#if DEBUG
struct ChangelogItemView_Previews: PreviewProvider {
    static let update = Changelog.versionUpdates.last!
    static var previews: some View {
        ChangelogItemView(item: (update.new + update.improved + update.fixed).first!)
    }
}
#endif
