//
//  CategoriesViewModelProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol CategoriesViewModelProtocol {
    // MARK: Bindings
    var onTrackerCategoriesStateChange: Binding<Bool>? { get set }
    var onSelectedTrackerCategoryStateChange: Binding<TrackerCategory>? { get set }
    
    // MARK: Properties
    var catgoriesCount: Int { get }
    
    // MARK: Methods
    func viewDidLoad()
    func categoryName(at indexPath: IndexPath) -> String
    func isSelectedCategory(at indexPath: IndexPath) -> Bool
    func selectCategory(at indexPath: IndexPath)
    func addCategory()
}
