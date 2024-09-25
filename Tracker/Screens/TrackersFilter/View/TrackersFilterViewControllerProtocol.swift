//
//  TrackersFilterViewControllerProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/17/24.
//

import UIKit

protocol TrackersFilterViewControllerProtocol: UIViewController {
    func configure(
        appliedFilter: TrackersFilter,
        delegate: TrackersFilterViewControllerDelegate
    )
}
