//
//  Int+Extensions.swift
//  Tracker
//
//  Created by Nikita Khon on 22.06.2025.
//

import Foundation

extension Int {
    
    var streakLabelText: String {
        let suffix =
        switch self % 100 {
            case 11...14: "дней"
                
            default: switch self % 10 {
                case 1: "день"
                case 2...4: "дня"
                default: "дней"
            }
        }
        
        return "\(self) \(suffix)"
    }
}
