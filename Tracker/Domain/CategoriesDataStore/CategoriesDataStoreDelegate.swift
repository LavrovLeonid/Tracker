//
//  CategoriesDataStoreDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol CategoriesDataStoreDelegate: AnyObject {
    func didUpdate(with updates: DataStoreUpdatesPropertiesProtocol)
    func editCategory(_ category: TrackerCategory)
}

extension CategoriesDataStoreDelegate {
    func didUpdate(with updates: DataStoreUpdatesPropertiesProtocol) {
        
    }
    
    func editCategory(_ category: TrackerCategory) {
        
    }
}
