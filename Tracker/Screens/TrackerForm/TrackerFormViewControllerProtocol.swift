//
//  TrackerFormViewControllerProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/9/24.
//

import UIKit

protocol TrackerFormViewControllerProtocol: UIViewController {
    func configure(trackerType: TrackerType, delegate: TrackerFormViewControllerDelegate?)
    func configure(
        with tracker: Tracker,
        completeCount: Int,
        at category: TrackerCategory,
        delegate: TrackerFormViewControllerDelegate?
    )
}
