//
//  CategoryEditorType.swift
//  Tracker
//
//  Created by Nikita Khon on 21.06.2025.
//

import Foundation

enum CategoryEditorType {
    case new, edit
    
    var title: String {
        switch self {
            case .new: "Новая категория"
            case .edit: "Редактирование категории"
        }
    }
}
