//
//  TrackerCategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/4/24.
//

import Foundation

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func createTracker(
        _ viewController: CreateTrackerViewControllerProtocol,
        trackerCategory: TrackerCategory,
        tracker: Tracker
    )
}
