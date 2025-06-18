//
//  TrackerStore.swift
//  Tracker
//
//  Created by Nikita Khon on 17.06.2025.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingError
}

final class TrackerStore {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext

    // MARK: - Initializers

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func addNewTracker(_ tracker: Tracker, toCategory title: String) throws {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        let trackerCategory: TrackerCategoryCoreData
        
        if let existingCategory = try context.fetch(fetchRequest).first {
            trackerCategory = existingCategory
        } else {
            trackerCategory = TrackerCategoryCoreData(context: context)
            trackerCategory.title = title
        }
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSObject
        trackerCoreData.category = trackerCategory

        try context.save()
    }
    
    static func tracker(from entity: TrackerCoreData) throws -> Tracker {
        guard
            let id = entity.id,
            let title = entity.title,
            let emoji = entity.emoji,
            let color = entity.color as? UIColor,
            let schedule = entity.schedule as? Set<WeekDay>
        else {
            throw TrackerStoreError.decodingError
        }
        
        return Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule)
    }
}
