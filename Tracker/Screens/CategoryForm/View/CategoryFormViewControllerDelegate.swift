//
//  CategoryFormViewControllerDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import UIKit

protocol CategoryFormViewControllerDelegate: AnyObject {
    func submitCategory(
        _ viewController: CategoryFormViewControllerProtocol,
        category: TrackerCategory
    )
}
