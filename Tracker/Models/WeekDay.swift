//
//  WeekDay.swift
//  Tracker
//
//  Created by Nikita Khon on 08.06.2025.
//

import Foundation

enum WeekDay: CaseIterable {
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
