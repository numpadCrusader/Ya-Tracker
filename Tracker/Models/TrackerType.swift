//
//  TrackerType.swift
//  Tracker
//
//  Created by Nikita Khon on 15.06.2025.
//

import Foundation

enum TrackerType {
    case habbit, task
    
    var title: String {
        switch self {
            case .habbit: "Новая привычка"
            case .task: "Новое нерегулярное событие"
        }
    }
    
    var details: [Detail] {
        switch self {
            case .habbit: [.category, .schedule]
            case .task: [.category]
        }
    }
}

extension TrackerType {
    
    enum Detail {
        case category, schedule
        
        var title: String {
            switch self {
                case .category: "Категория"
                case .schedule: "Расписание"
            }
        }
    }
}
