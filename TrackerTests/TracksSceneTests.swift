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

    func testEmptyTracksViewController() {
        let viewController = TracksViewController()
        assertSnapshot(of: viewController, as: .image)
    }
}
