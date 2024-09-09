//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

final class CategoriesViewModel: CategoriesViewModelProtocol {
    // MARK: Models
    private var trackersDataStore: DataStoreProtocol
    private var categoriesModel: CategoriesModelProtocol
    
    // MARK: Bindings
    var onTrackerCategoriesStateChange: Binding<Bool>?
    var onSelectedTrackerCategoryStateChange: Binding<TrackerCategory>?
    
    // MARK: Properties
    var catgoriesCount: Int {
        trackersDataStore.numberOfSections
    }
    
    // MARK: Initialization
    init(
        dataStore: DataStoreProtocol,
        categoriesModel: CategoriesModelProtocol
    ) {
        trackersDataStore = dataStore
        self.categoriesModel = categoriesModel
        
        trackersDataStore.setDelegate(self)
    }
    
    // MARK: Methods
    func viewDidLoad() {
        onTrackerCategoriesStateChange?(trackersDataStore.isEmptyTrackerCateogries)
    }
    
    func categoryName(at indexPath: IndexPath) -> String {
        trackersDataStore.category(at: indexPath.item).name
    }
    
    func isSelectedCategory(at indexPath: IndexPath) -> Bool {
        trackersDataStore.category(at: indexPath.item) == categoriesModel.selectedCategory
    }
    
    func selectCategory(at indexPath: IndexPath) {
        let category = trackersDataStore.category(at: indexPath.item)
        
        categoriesModel.setSelectedCategory(category)
        
        onSelectedTrackerCategoryStateChange?(category)
    }
    
    func addCategory() {
        
    }
}

// MARK: DataStoreDelegate
extension CategoriesViewModel: DataStoreDelegate {
    func didUpdate() {
        onTrackerCategoriesStateChange?(trackersDataStore.isEmptyTrackerCateogries)
    }
}
