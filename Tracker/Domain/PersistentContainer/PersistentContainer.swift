//
//  PersistentContainer.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/15/24.
//

import CoreData

final class PersistentContainer {
    // MARK: Singleton
    static let shared = PersistentContainer()
    private init() {}
    
    // MARK: Properties
    private let persistentContainerName = "TrackerModel"
    
    // MARK: Context
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: Persistent container
    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: persistentContainerName)
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Ошибка создания контейнера базы данных: \(error), \(error.userInfo)")
            }
        }
        
        return persistentContainer
    }()
}
