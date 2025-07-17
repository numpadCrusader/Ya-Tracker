//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Nikita Khon on 17.06.2025.
//

import Foundation
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func storeDidUpdate()
}

protocol TrackerRecordStoreProtocol: AnyObject {
    var delegate: TrackerRecordStoreDelegate? { get set }
    var trackerRecords: [TrackerRecordCoreData] { get }
    
    func addRecord(_ record: TrackerRecord)
    func deleteRecord(_ record: TrackerRecord)
    func hasRecord(for trackerId: UUID, on date: Date) -> Bool
    func recordCount(for trackerId: UUID) -> Int
}

final class TrackerRecordStore: NSObject, TrackerRecordStoreProtocol {
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    var trackerRecords: [TrackerRecordCoreData] {
        fetchedResultsController?.fetchedObjects ?? []
    }
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?

    // MARK: - Initializers

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    // MARK: - Public Methods
    
    func addRecord(_ record: TrackerRecord) {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", record.trackerId as CVarArg)
        
        guard let existingTracker = try? context.fetch(fetchRequest).first else {
            return
        }
        
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.trackerId = record.trackerId
        recordCoreData.date = record.date
        recordCoreData.tracker = existingTracker
        
        try? context.save()
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "trackerId == %@", record.trackerId as CVarArg),
            NSPredicate(format: "date == %@", record.date as CVarArg)
        ])
        
        if let existingRecord = try? context.fetch(fetchRequest).first {
            context.delete(existingRecord)
            try? context.save()
        }
    }
    
    func hasRecord(for trackerId: UUID, on date: Date) -> Bool {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "trackerId == %@", trackerId as CVarArg),
            NSPredicate(format: "date == %@", date as CVarArg)
        ])
        
        guard let _ = try? context.fetch(fetchRequest).first else {
            return false
        }
        
        return true
    }
    
    func recordCount(for trackerId: UUID) -> Int {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerId == %@", trackerId as CVarArg)
        
        guard let count = try? context.count(for: fetchRequest) else {
            return 0
        }
        
        return count
    }
    
    // MARK: - Private Methods
    
    private func setupFetchedResultsController() {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)
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
            print("TrackerRecordStore Error: \(error)")
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        delegate?.storeDidUpdate()
    }
}
