//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Nikita Khon on 17.06.2025.
//

import UIKit
import CoreData

protocol TrackerRecordStoreProtocol: AnyObject {
    func addRecord(_ record: TrackerRecord)
    func deleteRecord(_ record: TrackerRecord)
    func hasRecord(for trackerId: UUID, on date: Date) -> Bool
    func recordCount(for trackerId: UUID) -> Int
}

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext

    // MARK: - Initializers

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
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
}
