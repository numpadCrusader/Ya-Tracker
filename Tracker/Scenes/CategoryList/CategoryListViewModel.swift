//
//  CategoryListViewModel.swift
//  Tracker
//
//  Created by Nikita Khon on 20.06.2025.
//

import UIKit

protocol CategoryListViewModelDelegate: AnyObject {
    func didFinish(with categoryTitle: String)
}

final class CategoryListViewModel {
    
    // MARK: - Public Properties
    
    var router: CategoryListRouting?
    weak var delegate: CategoryListViewModelDelegate?
    
    var categoriesBinding: Binding<[CategoryCellViewModel]>?
    var tableSelectBinding: Binding<IndexPath>?
    var tableDeselectBinding: Binding<IndexPath>?
    var tableDeleteAttemptBinding: Binding<IndexPath>?
    
    // MARK: - Private Properties
    
    private var trackerCategoryStore: TrackerCategoryStoreProtocol
    private var chosenCategory: String?
    
    private(set) var categories: [CategoryCellViewModel] = []
    
    // MARK: - Initializers
    
    init(
        trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore(),
        chosenCategory: String?
    ) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerCategoryStore.delegate = self
        self.chosenCategory = chosenCategory
    }
    
    // MARK: - Public Methods
    
    func onViewDidLoad() {
        categories = getCategoriesFromStore()
        categoriesBinding?(categories)
    }
    
    func routeToCategoryEditor() {
        router?.routeToCategoryEditor(ofType: .new)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        guard indexPath.row < categories.count else {
            return
        }
        
        if let previousIndex = categories.firstIndex(where: \.isSelected),
           previousIndex != indexPath.row {
            let updatedOldViewModel = categories[previousIndex].copy(withSelected: false)
            categories[previousIndex] = updatedOldViewModel
            tableDeselectBinding?(IndexPath(row: previousIndex, section: 0))
        }
        
        let selectedViewModel = categories[indexPath.row].copy(withSelected: true)
        categories[indexPath.row] = selectedViewModel
        
        delegate?.didFinish(with: selectedViewModel.categoryTitle)
        tableSelectBinding?(indexPath)
    }
    
    func didAttempToDeleteCell(at indexPath: IndexPath) {
        tableDeleteAttemptBinding?(indexPath)
    }
    
    func deleteCell(at indexPath: IndexPath) {
        guard indexPath.row < categories.count else {
            return
        }
        
        let viewModel = categories[indexPath.row]
        trackerCategoryStore.deleteCategory(with: viewModel.categoryTitle)
    }
    
    func editCell(at indexPath: IndexPath) {
        guard indexPath.row < categories.count else {
            return
        }
        
        let viewModel = categories[indexPath.row]
        router?.routeToCategoryEditor(ofType: .edit(viewModel.categoryTitle))
    }
    
    // MARK: - Private Methods
    
    private func getCategoriesFromStore() -> [CategoryCellViewModel] {
        let categories = trackerCategoryStore.trackerCategories
        let lastIndex = categories.count - 1
        
        return categories.enumerated().compactMap { (index, entity) in
            let title = entity.title ?? ""
            let isSelected = chosenCategory ?? "" == entity.title
            
            let maskedCorners: CACornerMask =
            switch index {
                case 0: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                case lastIndex: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                default: []
            }
            
            return CategoryCellViewModel(
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
