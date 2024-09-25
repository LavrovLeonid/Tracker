//
//  TrackerSnapshotTests.swift
//  TrackerTests
//
//  Created by Леонид Лавров on 9/22/24.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerSnapshotTests: XCTestCase {
    func testViewController() {
        let mainTabBarViewController = SplashViewController().createMainTabBar()
        
        assertSnapshot(matching: mainTabBarViewController, as: .image)
    }
    
    func testViewControllerDarkTheme() {
        let mainTabBarViewController = SplashViewController().createMainTabBar()
        
        mainTabBarViewController.overrideUserInterfaceStyle = .dark
        
        assertSnapshot(matching: mainTabBarViewController, as: .image)
    }
}
