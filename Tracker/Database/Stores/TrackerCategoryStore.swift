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
    var trackerCategories: [TrackerCategory] { get }
    var delegate: TrackerCategoryStoreDelegate? { get set }
}

final class TrackerCategoryStore: NSObject, TrackerCategoryStoreProtocol {
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var trackerCategories: [TrackerCategory] {
        guard let objects = fetchedResultsController?.fetchedObjects else {
            return []
        }
        
        return objects.compactMap ({ trackerCategory(from: $0) })
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
    
    private func trackerCategory(from entity: TrackerCategoryCoreData) -> TrackerCategory? {
        guard
            let title = entity.title,
            let trackerSet = entity.trackers as? Set<TrackerCoreData>
        else {
            return nil
        }
        
        let trackers = trackerSet.compactMap { TrackerStore.tracker(from: $0) }
        
        return TrackerCategory(title: title, trackers: trackers)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate()
    }
}
