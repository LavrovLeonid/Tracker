//
//  TrackersFilterViewControllerDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/17/24.
//

import Foundation

protocol TrackersFilterViewControllerDelegate: AnyObject {
    func applyFilter(
        _ viewController: TrackersFilterViewControllerProtocol,
        filter: TrackersFilter
    )
}
