//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Nikita Khon on 18.06.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Public Properties
    
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Private Properties
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerStore")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Core Data Error: \(error). \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Initializers
    
    private init() {}
}
