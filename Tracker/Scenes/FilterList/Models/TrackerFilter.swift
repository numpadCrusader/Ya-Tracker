//
//  TrackerFilter.swift
//  Tracker
//
//  Created by Nikita Khon on 10.07.2025.
//

import Foundation

enum TrackerFilter: CaseIterable {
    case all, today, done, undone
    
    var title: String {
        switch self {
            case .all: "Все трекеры"
            case .today: "Трекеры на сегодня"
            case .done: "Завершенные"
            case .undone: "Не завершенные"
        }
    }
}
