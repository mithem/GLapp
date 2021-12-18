//
//  SubjectAttributeView.swift
//  SubjectAttributeView
//
//  Created by Miguel Themann on 19.10.21.
//

import SwiftUI

struct SubjectAttributeView: View { let attribute: LocalizedStringKey
    let value: String
    
    var body: some View {
        HStack {
            Text(attribute)
                .bold()
            Spacer()
            Text(value)
        }
    }
    
    init(_ attribute: LocalizedStringKey, value: String) {
        self.attribute = attribute
        self.value = value
    }
}

struct SubjectAttributeView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectAttributeView("subject_type", value: "LK1")
    }
}
