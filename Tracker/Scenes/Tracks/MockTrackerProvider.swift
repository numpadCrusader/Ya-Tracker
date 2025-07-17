//
//  MockTrackerProvider.swift
//  Tracker
//
//  Created by Nikita Khon on 17.07.2025.
//

import Foundation

struct MockTrackerProvider {
    
    static func makeMockTrackers() -> [TrackerCategory] {
        let mockUuid = UUID()
        
        return [
            TrackerCategory(
                title: "Test Category 1",
                trackers: [
                    Tracker(
                        id: mockUuid,
                        title: "Test Tracker 1",
                        color: .selection8,
                        emoji: "🛠️",
                        schedule: Set(WeekDay.allCases))
                ]),
            TrackerCategory(
                title: "Test Category 2",
                trackers: [
                    Tracker(
                        id: mockUuid,
                        title: "Test Tracker 2",
                        color: .selection14,
                        emoji: "🛠️",
                        schedule: Set(WeekDay.allCases))
                ]),
            TrackerCategory(
                title: "Test Category 3",
                trackers: [
                    Tracker(
                        id: mockUuid,
                        title: "Test Tracker 3",
                        color: .selection12,
                        emoji: "🛠️",
                        schedule: Set(WeekDay.allCases))
                ])
        ]
    }
}
