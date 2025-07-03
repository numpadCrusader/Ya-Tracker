//
//  TrackerStore.swift
//  Tracker
//
//  Created by Nikita Khon on 17.06.2025.
//

import Foundation
import CoreData

protocol TrackerStoreProtocol {
    func addNewTracker(_ tracker: Tracker, toCategory title: String)
    func deleteTracker(_ tracker: Tracker)
    func updateTracker(with newTracker: Tracker, toCategory newTitle: String)
    func pinTracker(_ tracker: Tracker)
    func unpinTracker(_ tracker: Tracker)
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
    
    func pinTracker(_ tracker: Tracker) {
        do {
            guard
                let existingTracker = fetchTracker(by: tracker.id),
                let currentCategoryTitle = existingTracker.category?.title
            else {
                print("TrackerStore Error: Pin conditions are not met")
                return
            }
            
            existingTracker.originCategoryTitle = currentCategoryTitle
            let trackerCategory = fetchOrCreateCategory(withTitle: "Закрепленные")
            existingTracker.category = trackerCategory
            
            try context.save()
        } catch {
            print("TrackerStore Error: \(error)")
        }
    }
    
    func unpinTracker(_ tracker: Tracker) {
        do {
            guard
                let existingTracker = fetchTracker(by: tracker.id),
                let originCategoryTitle = existingTracker.originCategoryTitle
            else {
                print("TrackerStore Error: Unpin conditions are not met")
                return
            }
            
            let trackerCategory = fetchOrCreateCategory(withTitle: originCategoryTitle)
            existingTracker.category = trackerCategory
            existingTracker.originCategoryTitle = nil
            
            try context.save()
        } catch {
            print("TrackerStore Error: \(error)")
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchTracker(by id: UUID) -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(request).first
    }
    
    private func fetchOrCreateCategory(withTitle title: String) -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        if let category = try? context.fetch(request).first {
            return category
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = title
            return newCategory
        }
    }
}
