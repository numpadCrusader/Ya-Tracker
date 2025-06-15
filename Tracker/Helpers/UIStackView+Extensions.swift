//
//  UIStackView+Extensions.swift
//  Tracker
//
//  Created by Nikita Khon on 15.06.2025.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
