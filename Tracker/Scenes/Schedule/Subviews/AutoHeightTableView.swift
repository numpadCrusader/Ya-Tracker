//
//  AutoHeightTableView.swift
//  Tracker
//
//  Created by Nikita Khon on 14.06.2025.
//

import UIKit

final class AutoHeightTableView: UITableView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return contentSize
    }
}
