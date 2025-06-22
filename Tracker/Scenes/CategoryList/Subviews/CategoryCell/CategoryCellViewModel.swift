//
//  CategoryCellViewModel.swift
//  Tracker
//
//  Created by Nikita Khon on 20.06.2025.
//

import UIKit

struct CategoryCellViewModel {
    let categoryTitle: String
    let isSelected: Bool
    let maskedCorners: CACornerMask
    let isSeparatorHidden: Bool
    
    var categoryTitleBinding: Binding<String>? {
        didSet {
            categoryTitleBinding?(categoryTitle)
        }
    }
    
    var isSelectedBinding: Binding<Bool>? {
        didSet {
            isSelectedBinding?(isSelected)
        }
    }
    
    var maskedCornersBinding: Binding<CACornerMask>? {
        didSet {
            maskedCornersBinding?(maskedCorners)
        }
    }
    
    var isSeparatorHiddenBinding: Binding<Bool>? {
        didSet {
            isSeparatorHiddenBinding?(isSeparatorHidden)
        }
    }
}

extension CategoryCellViewModel {
    
    func copy(withSelected isSelected: Bool) -> CategoryCellViewModel {
        CategoryCellViewModel(
            categoryTitle: categoryTitle,
            isSelected: isSelected,
            maskedCorners: maskedCorners,
            isSeparatorHidden: isSeparatorHidden)
    }
}
