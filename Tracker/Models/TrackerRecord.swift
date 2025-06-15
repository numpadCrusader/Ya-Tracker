//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Nikita Khon on 08.06.2025.
//

import Foundation

struct TrackerRecord {
    let trackerId: UUID
    let date: Date
}

extension TrackerRecord: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackerId)
        hasher.combine(date)
    }

    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
        return lhs.trackerId == rhs.trackerId && lhs.date == rhs.date
    }
}
