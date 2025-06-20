//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Nikita Khon on 08.06.2025.
//

import Foundation

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

extension TrackerCategory {
    
    init?(from entity: TrackerCategoryCoreData) {
        guard
            let title = entity.title,
            let trackerSet = entity.trackers as? Set<TrackerCoreData>
        else {
            return nil
        }

        let trackers = trackerSet.compactMap { TrackerStore.tracker(from: $0) }
        self = TrackerCategory(title: title, trackers: trackers)
    }
}
