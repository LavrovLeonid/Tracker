//
//  CategoryFormModel.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

final class CategoryFormModel: CategoryFormModelProtocol {
    var initialCategory: TrackerCategory?
    var categoryName: String
    
    init(initialCategory: TrackerCategory? = nil) {
        self.initialCategory = initialCategory
        categoryName = initialCategory?.name ?? ""
    }
    
    func setCategoryName(_ name: String) {
        categoryName = name
    }
}
