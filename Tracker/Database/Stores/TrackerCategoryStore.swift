//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Nikita Khon on 17.06.2025.
//

import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidTrackers
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidUpdate()
}

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var trackerCategories: [TrackerCategory] {
        guard
            let objects = fetchedResultsController?.fetchedObjects,
            let categories = try? objects.map({ try self.trackerCategory(from: $0) })
        else {
            return []
        }
        
        return categories
    }
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?

    // MARK: - Initializers

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) throws {
        self.context = context
        super.init()
        try setupFetchedResultsController()
    }
    
    // MARK: - Private Methods
    
    private func setupFetchedResultsController() throws {
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
        try controller.performFetch()
    }
    
    private func trackerCategory(from entity: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = entity.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        
        guard let trackerSet = entity.trackers as? Set<TrackerCoreData> else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
        }
        
        let trackers = try trackerSet.map { try TrackerStore.tracker(from: $0) }
        
        return TrackerCategory(title: title, trackers: trackers)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate()
    }
}
