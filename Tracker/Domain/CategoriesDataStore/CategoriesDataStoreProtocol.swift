//
//  CategoriesDataStoreProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol CategoriesDataStoreProtocol: NSObjectProtocol {
    var isEmptyCateogries: Bool { get }
    var categoriesCount: Int { get }
    
    func setDelegate(_ delegate: CategoriesDataStoreDelegate)
    func category(at index: Int) -> TrackerCategory
    func addCategory(_ category: TrackerCategory)
    func removeCategory(_ category: TrackerCategory)
    func editCategory(_ category: TrackerCategory)
    func hasCategory(with name: String) -> Bool
}
