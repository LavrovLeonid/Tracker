//
//  DataStoreUpdatesPropertiesProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/11/24.
//

import Foundation
import CoreData

protocol DataStoreUpdatesPropertiesProtocol {
    var insertedSectionsIndexes: IndexSet { get }
    var updatedSectionsIndexes: IndexSet { get }
    var deletedSectionsIndexes: IndexSet { get }
    
    var insertedItemsIndexPaths: [IndexPath] { get }
    var updatedItemsIndexPaths: [IndexPath] { get }
    var movedItemsIndexPaths: [(at: IndexPath, to: IndexPath)] { get }
    var deletedItemsIndexPaths: [IndexPath] { get }
}
