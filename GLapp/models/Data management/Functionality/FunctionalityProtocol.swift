//
//  FunctionalityProtocol.swift
//  FunctionalityProtocol
//
//  Created by Miguel Themann on 21.10.21.
//

import Foundation

protocol FunctionalityProtocol {
    var title: String { get }
    var description: String { get }
    var role: Functionality.Role { get }
    var id: String { get }
    /// Whether the current device/setup supports the functionality and dependencies are enabled
    var isSupported: Functionality.State { get }
    /// Whether the functionality is enabled by the user (required it to be supported)
    var isEnabled: Functionality.State { get }
    /// Whether the current feature configuration may require the user's attention.
    var mayRequireUsersAttention: Functionality.State { get }
    /// Dependency functionalities that need to be enabled in order for this functionality to be supported
    var dependencies: [Functionality.FunctionalityType] { get }
    
    /// Localized string keys for a human readable description of the state
    var stateDescription: String { get }
    
    /// Reload all isSupported & isEnabled. Must be run on main thread.
    func reload(with appManager: AppManager, dataManager: DataManager) throws
    /// Check whether the functionality is supported or not.
    ///
    /// Called from the main thread.
    func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws
    /// Check whether the functionality is enabled or not.
    ///
    /// Called from the main thread.
    func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws
    /// Call doEnable and reload isEnabled.
    func enable(with appManager: AppManager, dataManager: DataManager, tappedByUser: Bool) throws
    /// Call doDisable and reload isEnabled.
    func disable(with appManager: AppManager, dataManager: DataManager) throws
    /// Perform the necesary work to enable the functionality. Don't reload whether activation was successful.
    func doEnable(with appManager: AppManager, dataManager: DataManager) throws
    func doEnable(with appManager: AppManager, dataManager: DataManager, tappedByUser: Bool) throws
    /// Perform the necesary work to disable the functionality. Don't reload whether activation was successful.
    func doDisable(with appManager: AppManager, dataManager: DataManager) throws
    
    init()
}

