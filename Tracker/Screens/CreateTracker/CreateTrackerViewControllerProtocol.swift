//
//  TrackerCategoryViewControllerProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/4/24.
//

import UIKit

protocol CreateTrackerViewControllerProtocol: UIViewController {
    func configure(with delegate: CreateTrackerViewControllerDelegate)
}
