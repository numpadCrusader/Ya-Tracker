//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Nikita Khon on 17.06.2025.
//

import Foundation
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidUpdate()
}

protocol TrackerCategoryStoreProtocol {
    var trackerCategories: [TrackerCategoryCoreData] { get }
    var delegate: TrackerCategoryStoreDelegate? { get set }
    
    func addNewCategory(with title: String)
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
    
    func addNewCategory(with title: String) {
        do {
            if let _ = fetchCategory(by: title) {
                print("TrackerCategoryStore Error: Category with title \(title) already exists")
                return
            }
            
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = title
            newCategory.sortPriority = title == GlobalConstants.pinCategory ? 0 : 1
            
            try context.save()
        } catch {
            print("TrackerCategoryStore Error: \(error)")
        }
    }
    
    func deleteCategory(with title: String) {
        do {
            guard let category = fetchCategory(by: title) else {
                print("TrackerCategoryStore Error: Could not find category to delete")
                return
            }
            
            context.delete(category)
            try context.save()
        } catch {
            print("TrackerCategoryStore Error: \(error)")
        }
    }
    
    func updateCategory(with title: String, to newTitle: String) {
        do {
            if let _ = fetchCategory(by: newTitle) {
                print("TrackerCategoryStore Update Error: Category with title \(title) already exists")
                return
            }
            
            guard let category = fetchCategory(by: title) else {
                print("TrackerCategoryStore Update Error: Could not find category to update")
                return
            }
            
            category.title = newTitle
            try context.save()
        } catch {
            print("TrackerCategoryStore Error: \(error)")
        }
    }
    
    // MARK: - Private Methods
    
    private func setupFetchedResultsController() {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.sortPriority, ascending: true),
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
    
    private func fetchCategory(by title: String) -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        return try? context.fetch(request).first
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate()
    }
}
