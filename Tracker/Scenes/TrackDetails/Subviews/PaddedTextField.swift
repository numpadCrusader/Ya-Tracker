//
//  PaddedTextField.swift
//  Tracker
//
//  Created by Nikita Khon on 15.06.2025.
//

import UIKit

final class PaddedTextField: UITextField {
    
    private let textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
    private let rightViewOffset: CGFloat = -12

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x += rightViewOffset
        return rect
    }
}
