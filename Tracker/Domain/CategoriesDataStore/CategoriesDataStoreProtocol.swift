//
//  CategoriesDataStoreProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol CategoriesDataStoreProtocol: NSObjectProtocol {
    var isEmptyCategories: Bool { get }
    var categoriesCount: Int { get }
    var delegate: CategoriesDataStoreDelegate? { get set }
    
    func category(at index: Int) -> TrackerCategory
    func addCategory(_ category: TrackerCategory)
    func removeCategory(_ category: TrackerCategory)
    func editCategory(_ category: TrackerCategory)
    func hasCategory(with name: String) -> Bool
}
