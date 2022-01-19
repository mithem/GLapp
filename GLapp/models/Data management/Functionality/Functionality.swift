//
//  Functionality.swift
//  Functionality
//
//  Created by Miguel Themann on 21.10.21.
//

import Foundation
import Combine
import SwiftUI

class Functionality: ObservableObject, FunctionalityProtocol, Identifiable {
    
    typealias Identifier = String
    typealias SetCompletion = (Result<Void, Functionality.Error>) -> Void
    
    let id: Identifier
    let title: String
    let description: String
    let role: Role
    @Published var isSupported: State
    @Published var isEnabled: State
    @Published var dependencies: [FunctionalityType]
    
    var mayRequireUsersAttention: State {
        isEnabled.reversed
    }
    
    var stateDescription: String {
        switch isEnabled {
        case .yes:
            return "currently_enabled"
        case .no:
            return "currently_disabled"
        case .unknown:
            return "unkown_state"
        case .semi:
            return "semi_enabled_state"
        }
    }
    
    func isEnabledBinding(appManager: AppManager, dataManager: DataManager, setCompletion: @escaping SetCompletion) -> Binding<Bool> {
        .init(get: {
            self.isEnabled == .yes
        }, set: { enabled in
            do {
                if enabled {
                    try self.enable(with: appManager, dataManager: dataManager)
                } else {
                    try self.disable(with: appManager, dataManager: dataManager)
                }
                setCompletion(.success(Void()))
            } catch {
                guard let error = error as? Error else { return }
                setCompletion(.failure(error))
            }
        })
    }
    
    final func enable(with appManager: AppManager, dataManager: DataManager, tappedByUser: Bool = false) throws {
        _ = try isSupportedByDependencies(with: appManager, dataManager: dataManager)
        do {
            try doEnable(with: appManager, dataManager: dataManager, tappedByUser: tappedByUser)
        } catch {
            isEnabled = .no
            throw error
        }
        try reload(with: appManager, dataManager: dataManager)
    }
    
    final func disable(with appManager: AppManager, dataManager: DataManager) throws {
        try doDisable(with: appManager, dataManager: dataManager)
        try reload(with: appManager, dataManager: dataManager)
    }
    
    func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        throw Error.notImplemented
    }
    
    func doEnable(with appManager: AppManager, dataManager: DataManager, tappedByUser: Bool = false) throws {
        try doEnable(with: appManager, dataManager: dataManager)
    }
    
    func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        throw Error.notImplemented
    }
    
    func doDisable(with appManager: AppManager, dataManager: DataManager, tappedByUser: Bool = false) throws {
        try doDisable(with: appManager, dataManager: dataManager)
    }
    
    final func reload(with appManager: AppManager, dataManager: DataManager) throws {
        do {
            _ = try isSupportedByDependencies(with: appManager, dataManager: dataManager)
        } catch {
            guard let error = error as? Error else { fatalError("isSupportedByDependencies threw an unexpected error.") }
            switch error {
            case .notSupported(_):
                isSupported = .no
                isEnabled = .no
                throw error
            default:
                break
            }
        }
        do {
            try reloadIsSupported(with: appManager, dataManager: dataManager)
        } catch {
            isSupported = .no
            isEnabled = .no
            throw error
        }
        if isSupported == .yes {
            do {
                try reloadIsEnabled(with: appManager, dataManager: dataManager)
            } catch {
                isEnabled = .no
                throw error
            }
        } else {
            isEnabled = isSupported
            if isEnabled == .no {
                try doDisable(with: appManager, dataManager: dataManager)
            }
        }
    }
    
    func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        throw Error.notImplemented
    }
    
    func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        throw Error.notImplemented
    }
    
    final func isSupportedByDependencies(with appManager: AppManager, dataManager: DataManager) throws -> State {
        var isSupported = State.yes
        var disabledDependencies = [Functionality]() // strictly speaking un-enabled but anyways..
        for type in self.dependencies {
            let depEnabled = appManager.functionality(of: type).isEnabled
            if depEnabled != .yes {
                if [.yes, .unknown, .semi].contains(isSupported) {
                    isSupported = depEnabled
                } else if depEnabled == .no {
                    isSupported = .no
                }
                disabledDependencies.append(appManager.functionality(of: type))
            }
        }
        if isSupported == .no && !disabledDependencies.isEmpty {
            throw Error.notSupported(message: disabledDependencies.map {$0.title}.joined(separator: ", ") + " " + NSLocalizedString("misconfigured"))
        }
        return isSupported
    }
    
    init(id: Identifier, role: Role, dependencies: [FunctionalityType]) {
        self.id = id
        self.title = NSLocalizedString("feature_" + id + "_title")
        self.description = NSLocalizedString("feature_" + id + "_description")
        self.role = role
        self.dependencies = dependencies
        self.isSupported = .unknown
        self.isEnabled = .unknown
    }
    
    required init() {
        fatalError("Not implemented.")
    }
    
    enum Error: Swift.Error, Equatable {
        case notSupported(message: String)
        case notImplemented
        case notAuthorized
        
        var localizedMessage: String {
            switch self {
            case .notSupported(let message):
                return NSLocalizedString("functionality_error_not_supported") + " " + NSLocalizedString(message) + "."
            case .notImplemented:
                return NSLocalizedString("not_implemented")
            case .notAuthorized:
                return NSLocalizedString("not_authorized")
            }
        }
    }
    
    enum State {
        case yes, no, unknown, semi
        
        var reversed: Self {
            switch self {
            case .yes:
                return .no
            case .no:
                return .yes
            case .unknown, .semi:
                return self
            }
        }
        
        var unwrapped: Bool {
            switch self {
            case .yes, .semi:
                return true
            case .no, .unknown:
                return false
            }
        }
    }
    
    enum Role {
        case optional, critical
    }
    
    enum FunctionalityType {
        case notifications, timeSensitiveNotifications, backgroundRefresh, backgroundReprPlanNotifications, classTestReminders, demoMode, coloredInlineSubjects, classTestPlan, calendarAccess, classTestCalendarEvents, spotlightIntegration, requireAuthentication
        
        var id: Identifier {
            switch self {
            case .notifications:
                return Constants.Identifiers.Functionalities.notifications
            case .backgroundRefresh:
                return Constants.Identifiers.Functionalities.backgroundRefresh
            case .backgroundReprPlanNotifications:
                return Constants.Identifiers.Functionalities.backgroundReprPlanNotifications
            case .classTestReminders:
                return Constants.Identifiers.Functionalities.classTestReminders
            case .demoMode:
                return Constants.Identifiers.Functionalities.demoMode
            case .coloredInlineSubjects:
                return Constants.Identifiers.Functionalities.coloredInlineSubjects
            case .classTestPlan:
                return Constants.Identifiers.Functionalities.classTestPlan
            case .calendarAccess:
                return Constants.Identifiers.Functionalities.calendarAccess
            case .classTestCalendarEvents:
                return Constants.Identifiers.Functionalities.classTestCalendarEvents
            case .spotlightIntegration:
                return Constants.Identifiers.Functionalities.spotlightIntegration
            case .timeSensitiveNotifications:
                return Constants.Identifiers.Functionalities.timeSensitiveNotifications
            case .requireAuthentication:
                return Constants.Identifiers.Functionalities.requireAuthentication
            }
        }
    }
}
