//
//  CategoryListRouter.swift
//  Tracker
//
//  Created by Nikita Khon on 21.06.2025.
//

import UIKit

protocol CategoryListRouting: AnyObject {
    func routeToCategoryEditor(ofType type: CategoryEditorType)
}

final class CategoryListRouter: CategoryListRouting {
    
    // MARK: - Public Properties
    
    weak var viewController: UIViewController?

    // MARK: - Public Methods
    
    func routeToCategoryEditor(ofType type: CategoryEditorType) {
        let controller = CategoryEditorViewController(editorType: type)
        let navController = UINavigationController(rootViewController: controller)
        viewController?.present(navController, animated: true)
    }
}
