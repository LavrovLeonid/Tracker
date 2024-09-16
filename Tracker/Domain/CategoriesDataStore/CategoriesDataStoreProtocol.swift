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
    var pinCategory: TrackerCategoryEntity { get }
    var delegate: CategoriesDataStoreDelegate { get set }
    
    func category(at indexPath: IndexPath) -> TrackerCategory
    func addCategory(_ category: TrackerCategory)
    func editCategory(_ category: TrackerCategory)
    func removeCategory(at indexPath: IndexPath)
    func hasCategory(with name: String) -> Bool
    func fetchTrackerCategoryEntityBy(name: String) -> TrackerCategoryEntity?
    func fetchTrackerCategoryEntityBy(id: TrackerCategoryId) -> TrackerCategoryEntity?
    func format(_ trackerCategoryEntity: TrackerCategoryEntity) -> TrackerCategory
}
