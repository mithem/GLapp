//
//  TestFunctionality.swift
//  GLappTests
//
//  Created by Miguel Themann on 11.11.21.
//

import XCTest
@testable import GLapp

class FTestFunctionality: Functionality {
    private var enabled: Bool
    override func doEnable(with appManager: AppManager, dataManager: DataManager) throws {
        enabled = true
        isEnabled = .yes
    }
    override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
        enabled = false
        isEnabled = .no
    }
    override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
        isSupported = .yes
    }
    override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
        isEnabled = enabled ? .yes : .no
    }
    
    init(dependencies: [FunctionalityType] = []) {
        enabled = false
        super.init(id: "tmp", role: .critical, dependencies: [])
    }
    
    required init() {
        enabled = false
        super.init(id: "tmp", role: .critical, dependencies: [])
    }
}

class TestFunctionality: XCTestCase {
    
    private var appManager: AppManager!
    private var dataManager: DataManager!
    
    class FEnabled: Functionality {
        override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
            isSupported = .yes
        }
        override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
            isEnabled = .yes
        }
    }
    
    class FDisabled: Functionality {
        override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
            isSupported = .no
        }
    }
    
    override func setUpWithError() throws {
        appManager = .init()
        dataManager = .init(appManager: appManager)
        try appManager.demoMode.enable(with: appManager, dataManager: dataManager)
        appManager.classTestPlan.isEnabled = .no
        appManager.backgroundRefresh.isEnabled = .unknown
    }
    
    func testNotImplementedFunctionsThrowError() {
        let functionality = Functionality(id: "tmp", role: .critical, dependencies: [])
        XCTAssertThrowsError(try functionality.enable(with: appManager, dataManager: dataManager))
        XCTAssertThrowsError(try functionality.disable(with: appManager, dataManager: dataManager))
        XCTAssertThrowsError(try functionality.reloadIsEnabled(with: appManager, dataManager: dataManager))
        XCTAssertThrowsError(try functionality.reloadIsSupported(with: appManager, dataManager: dataManager))
        
        XCTAssertEqual(functionality.isSupported, .unknown)
        XCTAssertEqual(functionality.isEnabled, .no)
    }
    
    func testIsSupportedByDependenciesYesNoDependencies() throws {
        let functionality = Functionality(id: "tmp", role: .critical, dependencies: [])
        XCTAssertEqual(try functionality.isSupportedByDependencies(with: appManager, dataManager: dataManager), .yes)
    }
    
    func testIsSupportedByDependenciesYesFulfilledDependencies() throws {
        let functionality = Functionality(id: "tmp", role: .critical, dependencies: [.demoMode])
        XCTAssertEqual(try functionality.isSupportedByDependencies(with: appManager, dataManager: dataManager), .yes)
    }
    
    func testIsSupportedByDependenciesUnkown() throws {
        let functionality = Functionality(id: "tmp", role: .critical, dependencies: [.backgroundRefresh, .demoMode])
        XCTAssertEqual(try functionality.isSupportedByDependencies(with: appManager, dataManager: dataManager), .unknown)
    }
    
    func testIsSupportedByDependenciesNo() {
        let functionality = Functionality(id: "tmp", role: .critical, dependencies: [.demoMode, .backgroundRefresh, .classTestPlan])
        XCTAssertThrowsError(try functionality.isSupportedByDependencies(with: appManager, dataManager: dataManager)) { error in
            XCTAssertEqual((error as! Functionality.Error).localizedMessage, NSLocalizedString("functionality_error_not_supported") + " " + NSLocalizedString("feature_background_refresh_title") + ", " + NSLocalizedString("feature_class_test_plan_title") + " " + NSLocalizedString("misconfigured") + ".")
        }
    }
    
    func testIsEnabledBindingCompletionClosureGetsFailure() {
        let functionality = Functionality(id: "tmp", role: .critical, dependencies: [])
        let binding = functionality.isEnabledBinding(appManager: appManager, dataManager: dataManager) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .notImplemented)
            default:
                XCTFail("Succeeded")
            }
        }
        binding.wrappedValue = false
        binding.wrappedValue = true
        binding.wrappedValue = false
    }
    
    func testIsEnabledBindingCompletionClosureGetsSuccess() {
        let functionality = FTestFunctionality()
        let binding = functionality.isEnabledBinding(appManager: appManager, dataManager: dataManager) { result in
            switch result {
            case .failure(_):
                XCTFail("Failed to change isEnabled")
            default:
                break
            }
        }
        binding.wrappedValue = false
        binding.wrappedValue = true
        binding.wrappedValue = false
    }
    
    func testReloadRethrowsEnableDisableMethods() throws {
        let functionality = Functionality(id: "tmp", role: .critical, dependencies: [])
        XCTAssertThrowsError(try functionality.reload(with: appManager, dataManager: dataManager))
    }
    
    func testReloadDisablesWhenSupportedUnkown() throws {
        class FMixedBag: FTestFunctionality {
            override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
                isSupported = .unknown
            }
            override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
                isEnabled = .yes
            }
        }
        let functionality = FMixedBag()
        try functionality.reload(with: appManager, dataManager: dataManager)
        functionality.isSupported = .unknown
        
        try functionality.reload(with: appManager, dataManager: dataManager)
        
        XCTAssertEqual(functionality.isSupported, .unknown)
        XCTAssertEqual(functionality.isEnabled, .unknown)
    }
    
    func testReloadDisablesWhenSupportedNo() throws {
        class FMixedBag: FTestFunctionality {
            var didRunDoDisable = false
            override func reloadIsSupported(with appManager: AppManager, dataManager: DataManager) throws {
                isSupported = .no
            }
            override func reloadIsEnabled(with appManager: AppManager, dataManager: DataManager) throws {
                isEnabled = .yes
            }
            override func doDisable(with appManager: AppManager, dataManager: DataManager) throws {
                isEnabled = .no
                didRunDoDisable = true
            }
        }
        let functionality = FMixedBag()
        try functionality.reload(with: appManager, dataManager: dataManager)
        functionality.isSupported = .unknown
        
        try functionality.reload(with: appManager, dataManager: dataManager)
        
        XCTAssertEqual(functionality.isSupported, .no)
        XCTAssertEqual(functionality.isEnabled, .no)
        XCTAssert(functionality.didRunDoDisable)
    }
}

