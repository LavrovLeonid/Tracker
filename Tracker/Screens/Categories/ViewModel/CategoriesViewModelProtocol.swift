//
//  CategoriesViewModelProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol CategoriesViewModelProtocol {
    // MARK: Bindings
    var onTrackerCategoriesEmptyStateChange: Binding<Bool>? { get set }
    var onTrackerCategoriesStateChange: Binding<DataStoreUpdates>? { get set }
    var onSelectedTrackerCategoryStateChange: Binding<TrackerCategory?>? { get set }
    
    // MARK: Properties
    var categoriesCount: Int { get }
    
    // MARK: Methods
    func viewDidLoad()
    func category(at indexPath: IndexPath) -> TrackerCategory
    func isSelectedCategory(at indexPath: IndexPath) -> Bool
    func selectCategory(at indexPath: IndexPath)
    func deleteCategory(at indexPath: IndexPath)
}
