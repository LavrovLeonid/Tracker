//
//  CategoriesModel.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

final class CategoriesModel: CategoriesModelProtocol {
    private(set) var selectedCategory: TrackerCategory?
    
    init(initialSelectedCategory: TrackerCategory? = nil) {
        selectedCategory = initialSelectedCategory
    }
    
    func setSelectedCategory(_ category: TrackerCategory) {
        selectedCategory = category
    }
}
