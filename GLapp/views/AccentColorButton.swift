//
//  AccentColorButton.swift
//  AccentColorButton
//
//  Created by Miguel Themann on 09.10.21.
//

import SwiftUI

struct AccentColorButton<Label>: View where Label: View {
    let label: Label
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {label})
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: UIConstants.rrCornerRadius))
    }
    
    init(label: @escaping () -> Label, action: @escaping () -> Void) {
        self.label = label()
        self.action = action
    }
    
    init(_ label: LocalizedStringKey, action: @escaping () -> Void)  where Label == Text {
        self.init(label: {Text(label)}, action: action)
    }
}

struct AccentColorButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        AccentColorButton("Press me") {
            print("pressed me!")
        }
    }
}
