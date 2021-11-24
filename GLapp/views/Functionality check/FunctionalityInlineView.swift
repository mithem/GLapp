//
//  FunctionalityInlineView.swift
//  FunctionalityInlineView
//
//  Created by Miguel Themann on 15.10.21.
//

import SwiftUI

struct FunctionalityInlineView: View {
    let functionality: Functionality
    @ObservedObject var appManager: AppManager
    @ObservedObject var dataManager: DataManager
    @State private var error: Functionality.Error?
    @State private var showingErrorActionSheet = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var littleHorizontalSpace: Bool {
        UIDevice.current.userInterfaceIdiom == .phone && horizontalSizeClass == .compact
    }
    
    var alignment: (text: TextAlignment, horizontal: HorizontalAlignment) {
        switch littleHorizontalSpace {
        case true:
            return (text: .trailing, horizontal: .trailing)
        case false:
            return (text: .leading, horizontal: .leading)
        }
    }
    
    var RawContent: some View {
        let enableBtn = Group {
            if functionality.isEnabled != .yes { // give ability to enable manually for .no, .unkown, .semi, e.g. when only provisional notifications are enabled
                AccentColorButton("enable") {
                    do {
                        try functionality.enable(with: appManager, dataManager: dataManager, tappedByUser: true)
                    } catch {
                        self.error = error as? Functionality.Error
                        showingErrorActionSheet = true
                    }
                }
            }
        }
        let hstack = HStack {
            Image(systemName: imageName)
                .foregroundColor(imageColor)
                .font(.largeTitle)
            if alignment.horizontal == .trailing {
                Spacer()
            }
            VStack(alignment: alignment.horizontal) {
                Text(NSLocalizedString(functionality.title))
                    .font(.title3)
                    .multilineTextAlignment(alignment.text)
                Text(NSLocalizedString(functionality.description))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(alignment.text)
                if functionality.isEnabled != .yes {
                    Spacer()
                    Text(NSLocalizedString(functionality.stateDescription))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(alignment.text)
                }
            }
        }
        return Group {
            if littleHorizontalSpace {
                VStack(alignment: alignment.horizontal) {
                    hstack
                    enableBtn
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: UIConstants.rrCornerRadius)
                        .foregroundColor(Color("lightContrastGray"))
                )
            } else {
                HStack {
                    hstack
                    Spacer()
                    enableBtn
                }
            }
        }
    }
    
    var body: some View {
        if #available(iOS 15, *) {
            RawContent
                .confirmationDialog("error_occured", isPresented: $showingErrorActionSheet, actions: {
                    Button("ok", role: .cancel) {
                    }
                }) {
                    Text(error?.localizedMessage ?? "unkown_error")
                }
        } else {
            RawContent
                .actionSheet(isPresented: $showingErrorActionSheet) {
                    ActionSheet(title: Text("error_occured"), message: Text(error?.localizedMessage ?? "unkown_error"))
                }
        }
    }
    
    var imageName: String {
        if #available(iOS 15, *) {
            switch functionality.isEnabled {
            case .unknown:
                return "questionmark.diamond"
            case .yes:
                return "checkmark.diamond"
            case .no:
                return "xmark.diamond"
            case .semi:
                return "minus.diamond"
            }
        } else {
            switch functionality.isEnabled {
            case .unknown:
                return "questionmark.diamond"
            case .yes:
                return "checkmark.seal"
            case .no:
                return "slash.circle"
            case .semi:
                return "minus.diamond"
            }
        }
    }
    
    var imageColor: Color {
        switch functionality.isEnabled {
        case .unknown:
            return .gray
        case .yes:
            return .green
        case .no:
            switch functionality.role {
            case .optional:
                return .yellow
            case .critical:
                return .red
            }
        case .semi:
            return .blue
        }
    }
}

struct FunctionalityInlineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FunctionalityInlineView(functionality: AppManager().notifications, appManager: .init(), dataManager: MockDataManager())
            FunctionalityInlineView(functionality: AppManager().backgroundRefresh, appManager: .init(), dataManager: MockDataManager())
        }
        .previewLayout(.sizeThatFits)
    }
}
