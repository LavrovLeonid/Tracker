//
//  CategoryFormViewModel.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

final class CategoryFormViewModel: CategoryFormViewModelProtocol {
    private let categoriesDataStore: CategoriesDataStoreProtocol
    private let categoryFormModel: CategoryFormModelProtocol
    
    var onEnableSubmitButtonStateChange: Binding<Bool>?
    var onIsNewCategoryStateChange: Binding<Bool>?
    var onInitialCategoryNameStateChange: Binding<String>?
    var onCategorySubmit: Binding<TrackerCategory>?
    
    init(
        categoriesDataStore: CategoriesDataStoreProtocol,
        categoryFormModel: CategoryFormModelProtocol
    ) {
        self.categoriesDataStore = categoriesDataStore
        self.categoryFormModel = categoryFormModel
    }
    
    func viewDidLoad() {
        onIsNewCategoryStateChange?(categoryFormModel.initialCategory == nil)
        onInitialCategoryNameStateChange?(categoryFormModel.categoryName)
        onEnableSubmitButtonStateChange?(validateCategoryName(categoryFormModel.categoryName))
    }
    
    func changeCategoryName(_ name: String) {
        categoryFormModel.setCategoryName(name)
        
        onEnableSubmitButtonStateChange?(validateCategoryName(categoryFormModel.categoryName))
    }
    
    func submit() {
        var trackerCategory: TrackerCategory
        
        if let initialCategory = categoryFormModel.initialCategory {
            trackerCategory = TrackerCategory(
                id: initialCategory.id,
                name: categoryFormModel.categoryName,
                trackers: initialCategory.trackers
            )
            
            categoriesDataStore.editCategory(trackerCategory)
        } else {
            trackerCategory = TrackerCategory(
                id: UUID(),
                name: categoryFormModel.categoryName,
                trackers: []
            )
            
            categoriesDataStore.addCategory(trackerCategory)
        }
        
        onCategorySubmit?(trackerCategory)
    }
    
    private func validateCategoryName(_ name: String) -> Bool {
        guard !name.isEmpty else { return false }
        guard !categoriesDataStore.hasCategory(with: name) else { return false }
        
        return true
    }
}
