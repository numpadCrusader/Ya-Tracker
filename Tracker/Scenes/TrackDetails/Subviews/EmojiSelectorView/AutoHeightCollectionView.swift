//
//  AutoHeightCollectionView.swift
//  Tracker
//
//  Created by Nikita Khon on 16.06.2025.
//

import UIKit

final class AutoHeightCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size.height != contentSize.height {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
