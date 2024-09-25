//
//  DataStoreUpdates.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/11/24.
//

import Foundation
import CoreData

// MARK: DataStoreUpdatesPropertiesProtocol
final class DataStoreUpdates: DataStoreUpdatesPropertiesProtocol {
    private(set) var insertedSectionsIndexes: IndexSet = .init()
    private(set) var updatedSectionsIndexes: IndexSet = .init()
    private(set) var deletedSectionsIndexes: IndexSet = .init()
    
    private(set) var insertedItemsIndexPaths: [IndexPath] = []
    private(set) var updatedItemsIndexPaths: [IndexPath] = []
    private(set) var movedItemsIndexPaths: [(at: IndexPath, to: IndexPath)] = []
    private(set) var deletedItemsIndexPaths: [IndexPath] = []
}

// MARK: DataStoreUpdatesMethodsProtocol
extension DataStoreUpdates: DataStoreUpdatesMethodsProtocol {
    func changeSections(for type: NSFetchedResultsChangeType, at index: Int) {
        switch type {
            case .insert:
                insertedSectionsIndexes.insert(index)
            case .delete:
                deletedSectionsIndexes.insert(index)
            case .move:
                break
            case .update:
                updatedSectionsIndexes.insert(index)
            @unknown default:
                break
        }
    }
    
    func changeItems(for type: NSFetchedResultsChangeType, at indexPath: IndexPath?, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                if let newIndexPath {
                    insertedItemsIndexPaths.append(newIndexPath)
                }
            case .delete:
                if let indexPath {
                    deletedItemsIndexPaths.append(indexPath)
                }
            case .move:
                if let indexPath, let newIndexPath {
                    movedItemsIndexPaths.append((indexPath, newIndexPath))
                }
            case .update:
                if let indexPath {
                    updatedItemsIndexPaths.append(indexPath)
                }
            @unknown default:
                break
        }
    }
    
    func reset() {
        insertedSectionsIndexes.removeAll()
        updatedSectionsIndexes.removeAll()
        deletedSectionsIndexes.removeAll()
        
        insertedItemsIndexPaths.removeAll()
        updatedItemsIndexPaths.removeAll()
        movedItemsIndexPaths.removeAll()
        deletedItemsIndexPaths.removeAll()
    }
}
