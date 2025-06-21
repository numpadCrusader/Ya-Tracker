//
//  CategoryListViewModel.swift
//  Tracker
//
//  Created by Nikita Khon on 20.06.2025.
//

import UIKit

protocol CategoryListViewModelDelegate: AnyObject {
    func didFinish(with category: (id: String, title: String))
}

final class CategoryListViewModel {
    
    // MARK: - Public Properties
    
    var router: CategoryListRouting?
    var categoriesBinding: Binding<[CategoryCellViewModel]>?
    weak var delegate: CategoryListViewModelDelegate?
    
    // MARK: - Private Properties
    
    private var trackerCategoryStore: TrackerCategoryStoreProtocol
    private var chosenCategory: (id: String, title: String)?
    
    private(set) var categories: [CategoryCellViewModel] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    // MARK: - Initializers
    
    init(
        trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore(),
        chosenCategory: (String, String)?
    ) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerCategoryStore.delegate = self
        self.chosenCategory = chosenCategory
        categories = getCategoriesFromStore()
    }
    
    // MARK: - Public Methods
    
    func routeToCategoryEditor() {
        router?.routeToCategoryEditor(initialText: nil)
    }
    
    // MARK: - Private Methods
    
    private func getCategoriesFromStore() -> [CategoryCellViewModel] {
        let categories = trackerCategoryStore.trackerCategories
        let lastIndex = categories.count - 1
        
        return categories.enumerated().compactMap { (index, entity) in
            let id = entity.objectID.uriRepresentation().absoluteString
            let title = entity.title ?? ""
            let isSelected = (chosenCategory?.id == id)
            
            let maskedCorners: CACornerMask =
            switch index {
                case 0: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                case lastIndex: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                default: []
            }
            
            return CategoryCellViewModel(
                id: id,
                categoryTitle: title,
                isSelected: isSelected,
                maskedCorners: maskedCorners,
                isSeparatorHidden: index == lastIndex)
        }
    }
}

// MARK: - TrackerCategoryStoreDelegate

extension CategoryListViewModel: TrackerCategoryStoreDelegate {
    
    func storeDidUpdate() {
        categories = getCategoriesFromStore()
    }
}
