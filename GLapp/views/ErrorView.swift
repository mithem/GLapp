//
//  ErrorView.swift
//  ErrorView
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

/// Can't get behind why the Button action doesn't seem to get triggered on tap
/// Leaving here (not deleting) for the future, as this does seem like some pretty subtle issue
struct ErrorView: View {
    let error: GLappError
    let callback: () -> ()
    var body: some View {
        VStack {
            Text(error.localizedMessage)
            AccentColorButton("retry", action: callback)
        }
    }
    
    init(error: GLappError, callback: @escaping () -> Void) {
        self.error = error
        self.callback = callback
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: NetworkError.notAuthorized) {}
    }
}
