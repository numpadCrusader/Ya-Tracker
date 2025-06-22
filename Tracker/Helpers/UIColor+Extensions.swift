//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Nikita Khon on 22.06.2025.
//

import UIKit

extension UIColor {
    func isEqualToColor(_ other: UIColor) -> Bool {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        other.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return abs(r1 - r2) < 0.01 &&
        abs(g1 - g2) < 0.01 &&
        abs(b1 - b2) < 0.01 &&
        abs(a1 - a2) < 0.01
    }
}
