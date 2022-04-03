//
//  DemoModeWarningView.swift
//  GLapp
//
//  Created by Miguel Themann on 28.03.22.
//

import SwiftUI

struct DemoModeWarningView: View {
    @ObservedObject var model: DemoModeWarningViewModel
    var body: some View {
        Button("demo_mode_excl") {
            model.deactivateDemoMode()
        }
        .padding()
        .foregroundColor(.red)
    }
    
    init(appManager: AppManager, dataManager: DataManager) {
        model = .init(appManager: appManager, dataManager: dataManager)
    }
}

#if DEBUG
struct DemoModeWarningView_Previews: PreviewProvider {
    static var previews: some View {
        DemoModeWarningView(appManager: .init(), dataManager: MockDataManager())
    }
}
#endif
