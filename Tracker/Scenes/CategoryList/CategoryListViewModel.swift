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
    weak var delegate: CategoryListViewModelDelegate?
    
    var categoriesBinding: Binding<[CategoryCellViewModel]>?
    var tableSelectBinding: Binding<IndexPath>?
    var tableDeselectBinding: Binding<IndexPath>?
    
    // MARK: - Private Properties
    
    private var trackerCategoryStore: TrackerCategoryStoreProtocol
    private var chosenCategory: (id: String, title: String)?
    
    private(set) var categories: [CategoryCellViewModel] = []
    
    // MARK: - Initializers
    
    init(
        trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore(),
        chosenCategory: (String, String)?
    ) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerCategoryStore.delegate = self
        self.chosenCategory = chosenCategory
        categories = getCategoriesFromStore()
        categoriesBinding?(categories)
    }
    
    // MARK: - Public Methods
    
    func routeToCategoryEditor() {
        router?.routeToCategoryEditor(initialText: nil)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        guard indexPath.row < categories.count else {
            return
        }
        
        if let previousIndex = categories.firstIndex(where: \.isSelected) {
            let updatedOldViewModel = categories[previousIndex].copy(withSelected: false)
            categories[previousIndex] = updatedOldViewModel
            tableDeselectBinding?(IndexPath(row: previousIndex, section: 0))
        }
        
        let selectedViewModel = categories[indexPath.row].copy(withSelected: true)
        categories[indexPath.row] = selectedViewModel
        
        delegate?.didFinish(with: (id: selectedViewModel.id, title: selectedViewModel.categoryTitle))
        tableSelectBinding?(indexPath)
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
        categoriesBinding?(categories)
    }
}
