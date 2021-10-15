//
//  EmptyContentView.swift
//  EmptyContentView
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

struct EmptyContentView: View {
    let image: String
    let text: String
    var body: some View {
        VStack(spacing: 50) {
            Image(systemName: image)
                .font(.title)
            Text(LocalizedStringKey(text))
                .foregroundColor(.secondary)
        }
    }
}

struct EmptyContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyContentView(image: "sparkles", text: "classTestPlan_empty")
    }
}
