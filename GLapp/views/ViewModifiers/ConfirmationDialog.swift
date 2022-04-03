//
//  ConfirmationDialog.swift
//  GLapp
//
//  Created by Miguel Themann on 03.12.21.
//

import SwiftUI

struct ConfirmationDialog<Provider>: ViewModifier where Provider: ConfirmationDialogProviding {
    typealias Button = (title: String, callback: () -> Void)
    @ObservedObject var provider: Provider
    let actionButtons: [Button]
    let cancelButtons: [Button]
    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            content
                .confirmationDialog(NSLocalizedString(provider.confirmationDialog?.title ?? "not_available"), isPresented: $provider.showingConfirmationDialog, titleVisibility: .visible, actions: {
                    ForEach(actionButtons, id: \.title) { button in
                        SwiftUI.Button(NSLocalizedString(button.title), action: button.callback)
                    }
                    ForEach(cancelButtons, id: \.title) { button in
                        SwiftUI.Button(NSLocalizedString(button.title), role: .cancel, action: button.callback)
                    }
                }, message: {
                    Text(NSLocalizedString(provider.confirmationDialog?.body ?? "not_available"))
                })
        } else {
            content
                .actionSheet(isPresented: $provider.showingConfirmationDialog) {
                    var buttons = [ActionSheet.Button]()
                    for button in actionButtons {
                        buttons.append(.default(Text(NSLocalizedString(button.title)), action: button.callback))
                    }
                    for button in cancelButtons {
                        buttons.append(.cancel(Text(NSLocalizedString(button.title)), action: button.callback))
                    }
                    return ActionSheet(title: .init(NSLocalizedString(provider.confirmationDialog?.title ?? "not_available")), message: .init(NSLocalizedString(provider.confirmationDialog?.body ?? "not_available")), buttons: buttons)
                }
        }
    }
    
    init(provider: Provider, actionButtons: [Button], cancelButtons: [Button] = []) {
        self.provider = provider
        self.actionButtons = actionButtons
        self.cancelButtons = cancelButtons
    }
}

protocol ConfirmationDialogProviding: ObservableObject {
    @MainActor var confirmationDialog: (title: String, body: String)? { get }
    @MainActor var showingConfirmationDialog: Bool { get set }
}

extension View {
    func confirmationDialog<Provider>(provider: Provider, actionButtons: [ConfirmationDialog.Button], cancelButtons: [ConfirmationDialog.Button] = []) -> some View where Provider: ConfirmationDialogProviding {
        modifier(ConfirmationDialog(provider: provider, actionButtons: actionButtons, cancelButtons: cancelButtons))
    }
}

fileprivate struct ConfirmationDialog_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationDialogDemo()
    }
}

fileprivate struct ConfirmationDialogDemo: View {
    @ObservedObject var provider: ConfirmationDialogProvider
    
    init() {
        provider = ConfirmationDialogProvider(title: "Hello, world!", body: "Hello, there!")
    }
    
    var body: some View {
        Button("Show dialog") {
            provider.showingConfirmationDialog = true
        }
            .confirmationDialog(provider: provider, actionButtons: [(title: "Press me!", callback: {print("pressed!")})])
    }
}

final class ConfirmationDialogProvider: ConfirmationDialogProviding {
    @Published var confirmationDialog: (title: String, body: String)?
    @Published var showingConfirmationDialog: Bool
    
    @MainActor init(title: String, body: String) {
        self.showingConfirmationDialog = false
        self.confirmationDialog = (title: title, body: body)
    }
}
