//
//  Tracker.swift
//  Tracker
//
//  Created by Nikita Khon on 08.06.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDay>
}

extension Tracker {
    
    init?(from entity: TrackerCoreData) {
        guard
            let id = entity.id,
            let title = entity.title,
            let emoji = entity.emoji,
            let color = entity.color as? UIColor,
            let schedule = entity.schedule as? Set<WeekDay>
        else {
            return nil
        }
        
        self = Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule)
    }
}
