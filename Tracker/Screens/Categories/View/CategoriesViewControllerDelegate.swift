//
//  CategoriesViewControllerDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol CategoriesViewControllerDelegate: AnyObject {
    func selectCategory(
        _ viewController: CategoriesViewControllerProtocol,
        category: TrackerCategory
    )
    func resetCategory(
        _ viewController: CategoriesViewControllerProtocol
    )
}
