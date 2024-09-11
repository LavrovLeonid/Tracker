//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

final class CategoriesViewModel: CategoriesViewModelProtocol {
    // MARK: Models
    private let categoriesDataStore: CategoriesDataStoreProtocol
    private let categoriesModel: CategoriesModelProtocol
    
    // MARK: Bindings
    var onTrackerCategoriesEmptyStateChange: Binding<Bool>?
    var onTrackerCategoriesStateChange: Binding<DataStoreUpdates>?
    var onSelectedTrackerCategoryStateChange: Binding<TrackerCategory?>?
    
    // MARK: Properties
    var categoriesCount: Int {
        categoriesDataStore.categoriesCount
    }
    
    // MARK: Initialization
    init(
        categoriesDataStore: CategoriesDataStoreProtocol,
        categoriesModel: CategoriesModelProtocol
    ) {
        self.categoriesDataStore = categoriesDataStore
        self.categoriesModel = categoriesModel
        
        categoriesDataStore.delegate = self
    }
    
    // MARK: Methods
    func viewDidLoad() {
        onTrackerCategoriesEmptyStateChange?(categoriesDataStore.isEmptyCategories)
    }
    
    func category(at indexPath: IndexPath) -> TrackerCategory {
        categoriesDataStore.category(at: indexPath.item)
    }
    
    func isSelectedCategory(at indexPath: IndexPath) -> Bool {
        categoriesDataStore.category(at: indexPath.item) == categoriesModel.selectedCategory
    }
    
    func selectCategory(at indexPath: IndexPath) {
        let category = categoriesDataStore.category(at: indexPath.item)
        
        categoriesModel.setSelectedCategory(category)
        
        onSelectedTrackerCategoryStateChange?(category)
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        let category = categoriesDataStore.category(at: indexPath.item)
        
        if category == categoriesModel.selectedCategory {
            categoriesModel.resetSelectedCategory()
            
            onSelectedTrackerCategoryStateChange?(nil)
        }
        
        categoriesDataStore.removeCategory(category)
    }
}

// MARK: DataStoreDelegate
extension CategoriesViewModel: CategoriesDataStoreDelegate {
    func didUpdate(with updates: DataStoreUpdates) {
        if categoriesDataStore.isEmptyCategories {
            onTrackerCategoriesEmptyStateChange?(categoriesDataStore.isEmptyCategories)
        } else {
            onTrackerCategoriesStateChange?(updates)
        }
    }
}
