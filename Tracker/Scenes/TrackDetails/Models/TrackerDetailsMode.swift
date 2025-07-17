//
//  TrackerDetailsMode.swift
//  Tracker
//
//  Created by Nikita Khon on 22.06.2025.
//

import Foundation

enum TrackerDetailsMode {
    case new(TrackerType)
    case edit(tracker: Tracker, ofCategory: String)
    
    var trackerType: TrackerType {
        switch self {
            case .new(let trackerType): trackerType
            case .edit(let tracker, _): tracker.schedule.isEmpty ? .task : .habit
        }
    }
    
    var title: String {
        switch self {
            case .new(let trackerType):
                trackerType == .habit ? "Новая привычка" : "Новое нерегулярное событие"
                
            case .edit:
                trackerType == .habit ? "Редактирование привычки" : "Редактирование нерегулярного события"
        }
    }
    
    var detailFields: [DetailField] {
        switch trackerType {
            case .habit: [.category, .schedule]
            case .task: [.category]
        }
    }
}

extension TrackerDetailsMode {
    
    enum DetailField {
        case category, schedule
        
        var title: String {
            switch self {
                case .category: "Категория"
                case .schedule: "Расписание"
            }
        }
    }
}
