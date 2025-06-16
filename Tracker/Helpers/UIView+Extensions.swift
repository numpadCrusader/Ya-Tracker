//
//  UIView+Extensions.swift
//  Tracker
//
//  Created by Nikita Khon on 07.05.2025.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
