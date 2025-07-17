//
//  TracksSceneTests.swift
//  TrackerTests
//
//  Created by Nikita Khon on 17.07.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TracksSceneTests: XCTestCase {

    func testLightEmptyTracksViewController() {
        let viewController = TracksViewController()
        
        assertSnapshot(
            of: viewController,
            as: .image(
                on: .iPhoneX,
                traits: .init(userInterfaceStyle: .light)))
    }
    
    func testLightFilledTracksViewController() {
        let viewController = TracksViewController()
        let _ = viewController.view
        viewController.makeMockTrackers()
        
        assertSnapshot(
            of: viewController,
            as: .image(
                on: .iPhoneX,
                traits: .init(userInterfaceStyle: .light)))
    }
    
    func testDarkEmptyTracksViewController() {
        let viewController = TracksViewController()
        
        assertSnapshot(
            of: viewController,
            as: .image(
                on: .iPhoneX,
                traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testDarkFilledTracksViewController() {
        let viewController = TracksViewController()
        let _ = viewController.view
        viewController.makeMockTrackers()
        
        assertSnapshot(
            of: viewController,
            as: .image(
                on: .iPhoneX,
                traits: .init(userInterfaceStyle: .dark)))
    }
}
