//
//  CategoriesViewModelProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol CategoriesViewModelProtocol {
    // MARK: Bindings
    var onCategoriesStateChange: Binding<DataStoreUpdatesPropertiesProtocol>? { get set }
    var onCategoriesPresentEmptyView: BindingWithoutValue? { get set }
    var onCategoriesPresentCollectionView: BindingWithoutValue? { get set }
    var onCategoriesReloadCollectionView: BindingWithoutValue? { get set }
    var onSelectedCategoryStateChange: Binding<TrackerCategory?>? { get set }
    
    // MARK: Properties
    var categoriesCount: Int { get }
    
    // MARK: Methods
    func viewDidLoad()
    func category(at indexPath: IndexPath) -> TrackerCategory
    func isSelectedCategory(at indexPath: IndexPath) -> Bool
    func selectCategory(at indexPath: IndexPath)
    func deleteCategory(at indexPath: IndexPath)
    func didFinishUpdates()
}
