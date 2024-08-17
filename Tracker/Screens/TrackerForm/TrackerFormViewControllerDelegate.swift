//
//  TrackerFormViewControllerDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/10/24.
//

import Foundation

protocol TrackerFormViewControllerDelegate: AnyObject {
    func trackerFormCancel(_ viewController: TrackerFormViewControllerProtocol)
    func trackerFormSubmit(
        _ viewController: TrackerFormViewControllerProtocol,
        trackerCategory: TrackerCategory,
        tracker: Tracker
    )
}
