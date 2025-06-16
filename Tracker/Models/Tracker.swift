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
