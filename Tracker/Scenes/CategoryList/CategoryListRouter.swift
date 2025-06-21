//
//  CategoryListRouter.swift
//  Tracker
//
//  Created by Nikita Khon on 21.06.2025.
//

import UIKit

protocol CategoryListRouting: AnyObject {
    func routeToCategoryEditor(initialText: String?)
}

final class CategoryListRouter: CategoryListRouting {
    
    // MARK: - Public Properties
    
    weak var viewController: UIViewController?

    // MARK: - Public Methods
    
    func routeToCategoryEditor(initialText: String? = nil) {
        let controller = CategoryEditorViewController(editorType: .new)
        let navController = UINavigationController(rootViewController: controller)
        viewController?.present(navController, animated: true)
    }
}
