//
//  DataStoreUpdatesMethodsProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/11/24.
//

import Foundation
import CoreData

protocol DataStoreUpdatesMethodsProtocol {
    func changeSections(
        for type: NSFetchedResultsChangeType,
        at index: Int
    )
    
    func changeItems(
        for type: NSFetchedResultsChangeType,
        at indexPath: IndexPath?,
        newIndexPath: IndexPath?
    )
    
    func reset()
}
