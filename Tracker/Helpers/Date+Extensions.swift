//
//  Date+Extensions.swift
//  Tracker
//
//  Created by Nikita Khon on 15.06.2025.
//

import Foundation

extension Date {
    
    var dateOnly: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var weekDay: WeekDay {
        WeekDay.from(date: self)
    }
}
