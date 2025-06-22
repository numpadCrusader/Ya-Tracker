//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Nikita Khon on 17.06.2025.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidUpdate()
}

protocol TrackerCategoryStoreProtocol {
    var trackerCategories: [TrackerCategoryCoreData] { get }
    var delegate: TrackerCategoryStoreDelegate? { get set }
    
    func addNewCategory(title: String)
    func deleteCategory(with title: String)
    func updateCategory(with title: String, to newTitle: String)
}

final class TrackerCategoryStore: NSObject, TrackerCategoryStoreProtocol {
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var trackerCategories: [TrackerCategoryCoreData] {
        fetchedResultsController?.fetchedObjects ?? []
    }
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?

    // MARK: - Initializers

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    // MARK: - Public Methods
    
    func addNewCategory(title: String) {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            if let _ = try context.fetch(fetchRequest).first {
                return
            }
            
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = title
            try context.save()
        } catch {
            print("TrackerCategoryStore Error: \(error)")
        }
    }
    
    func deleteCategory(with title: String) {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            if let category = try context.fetch(fetchRequest).first {
                context.delete(category)
                try context.save()
            }
        } catch {
            print("TrackerCategoryStore Error: \(error)")
        }
    }
    
    func updateCategory(with title: String, to newTitle: String) {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.fetchLimit = 1
        
        let duplicateCheckRequest = TrackerCategoryCoreData.fetchRequest()
        duplicateCheckRequest.predicate = NSPredicate(format: "title == %@", newTitle)
        duplicateCheckRequest.fetchLimit = 1
        
        do {
            if let _ = try context.fetch(duplicateCheckRequest).first {
                return
            }
            
            if let category = try context.fetch(fetchRequest).first {
                category.title = newTitle
                try context.save()
            }
        } catch {
            print("TrackerCategoryStore Error: \(error)")
        }
    }
    
    // MARK: - Private Methods
    
    private func setupFetchedResultsController() {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        controller.delegate = self
        fetchedResultsController = controller
        
        do {
            try controller.performFetch()
        } catch {
            print("TrackerCategoryStore Error: \(error)")
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate()
    }
}
