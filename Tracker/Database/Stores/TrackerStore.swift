//
//  TrackerStore.swift
//  Tracker
//
//  Created by Nikita Khon on 17.06.2025.
//

import UIKit
import CoreData

protocol TrackerStoreProtocol {
    func addNewTracker(_ tracker: Tracker, toCategory title: String)
    func deleteTracker(_ tracker: Tracker)
    func updateTracker(with newTracker: Tracker, toCategory newTitle: String)
}

final class TrackerStore: TrackerStoreProtocol {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext

    // MARK: - Initializers

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func addNewTracker(_ tracker: Tracker, toCategory title: String) {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        let trackerCategory: TrackerCategoryCoreData
        
        if let existingCategory = try? context.fetch(fetchRequest).first {
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

        do {
            try context.save()
        } catch {
            print("TrackerStore Error: \(error)")
        }
    }
    
    func deleteTracker(_ tracker: Tracker) {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            if let tracker = try context.fetch(fetchRequest).first {
                context.delete(tracker)
                try context.save()
            }
        } catch {
            print("TrackerStore Error: \(error)")
        }
    }
    
    func updateTracker(with newTracker: Tracker, toCategory newTitle: String) {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", newTracker.id as CVarArg)
        
        do {
            guard let oldTracker = try context.fetch(fetchRequest).first else {
                return
            }
            
            oldTracker.title = newTracker.title
            oldTracker.emoji = newTracker.emoji
            oldTracker.color = newTracker.color
            oldTracker.schedule = newTracker.schedule as NSObject
            
            if oldTracker.category?.title == newTitle {
                oldTracker.category?.willChangeValue(forKey: "trackers")
                oldTracker.category?.didChangeValue(forKey: "trackers")
            } else {
                let categoryFetch = TrackerCategoryCoreData.fetchRequest()
                categoryFetch.predicate = NSPredicate(format: "title == %@", newTitle)
                
                let trackerCategory: TrackerCategoryCoreData
                if let existingCategory = try context.fetch(categoryFetch).first {
                    trackerCategory = existingCategory
                } else {
                    trackerCategory = TrackerCategoryCoreData(context: context)
                    trackerCategory.title = newTitle
                }
                
                oldTracker.category = trackerCategory
            }
            
            try context.save()
        } catch {
            print("TrackerStore Error: \(error)")
        }
    }
}
