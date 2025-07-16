//
//  StatsType.swift
//  Tracker
//
//  Created by Nikita Khon on 16.07.2025.
//

import Foundation

enum StatsType: CaseIterable {
    case totalDone
    
    var title: String {
        switch self {
            case .totalDone: "Трекеров завершено"
        }
    }
}
