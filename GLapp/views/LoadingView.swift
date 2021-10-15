//
//  LoadingView.swift
//  LoadingView
//
//  Created by Miguel Themann on 10.10.21.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 35) {
            ProgressView()
            Text("loading_msg")
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
