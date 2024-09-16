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
    var onCategoriesStateChange: Binding<DataStoreUpdatesPropertiesProtocol>?
    var onCategoriesPresentEmptyView: BindingWithoutValue?
    var onCategoriesPresentCollectionView: BindingWithoutValue?
    var onCategoriesReloadCollectionView: BindingWithoutValue?
    var onSelectedCategoryStateChange: Binding<TrackerCategory?>?
    
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
        if categoriesDataStore.isEmptyCategories {
            onCategoriesPresentEmptyView?()
        } else {
            onCategoriesPresentCollectionView?()
            onCategoriesReloadCollectionView?()
        }
    }
    
    func category(at indexPath: IndexPath) -> TrackerCategory {
        categoriesDataStore.category(at: indexPath)
    }
    
    func isSelectedCategory(at indexPath: IndexPath) -> Bool {
        categoriesDataStore.category(at: indexPath) == categoriesModel.selectedCategory
    }
    
    func selectCategory(at indexPath: IndexPath) {
        let category = categoriesDataStore.category(at: indexPath)
        
        categoriesModel.setSelectedCategory(category)
        
        onSelectedCategoryStateChange?(category)
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        if categoriesModel.selectedCategory == categoriesDataStore.category(at: indexPath) {
            categoriesModel.resetSelectedCategory()
            
            onSelectedCategoryStateChange?(nil)
        }
        
        categoriesDataStore.removeCategory(at: indexPath)
    }
    
    func didFinishUpdates() {
        if categoriesDataStore.isEmptyCategories {
            onCategoriesPresentEmptyView?()
        }
    }
}

// MARK: DataStoreDelegate
extension CategoriesViewModel: CategoriesDataStoreDelegate {
    func didUpdate(with updates: DataStoreUpdatesPropertiesProtocol) {
        onCategoriesStateChange?(updates)
    }
}
