//
//  StatsType.swift
//  Tracker
//
//  Created by Nikita Khon on 16.07.2025.
//

import Foundation

enum StatsType {
    case totalDone(Int)
    
    var title: String {
        switch self {
            case .totalDone: "Трекеров завершено"
        }
    }
    
    var count: Int {
        switch self {
            case .totalDone(let count): count
        }
    }
}
