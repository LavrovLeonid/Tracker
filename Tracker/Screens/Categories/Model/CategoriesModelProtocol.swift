//
//  CategoriesModelProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol CategoriesModelProtocol {
    // MARK: Properties
    var selectedCategory: TrackerCategory? { get }
    
    // MARK: Methods
    func setSelectedCategory(_ category: TrackerCategory)
}
