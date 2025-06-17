//
//  WeekDay.swift
//  Tracker
//
//  Created by Nikita Khon on 08.06.2025.
//

import Foundation

enum WeekDay: CaseIterable, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var name: String {
        switch self {
            case .monday: "Понедельник"
            case .tuesday: "Вторник"
            case .wednesday: "Среда"
            case .thursday: "Четверг"
            case .friday: "Пятница"
            case .saturday: "Суббота"
            case .sunday: "Воскресенье"
        }
    }
    
    var shortName: String {
        switch self {
            case .monday: "Пн"
            case .tuesday: "Вт"
            case .wednesday: "Ср"
            case .thursday: "Чт"
            case .friday: "Пт"
            case .saturday: "Сб"
            case .sunday: "Вс"
        }
    }
}

extension WeekDay {
    
    static func from(date: Date) -> WeekDay {
        let weekdayNumber = Calendar.current.component(.weekday, from: date)
        let mapping: [Int: WeekDay] = [
            1: .sunday,
            2: .monday,
            3: .tuesday,
            4: .wednesday,
            5: .thursday,
            6: .friday,
            7: .saturday
        ]
        return mapping[weekdayNumber] ?? .monday
    }
}
