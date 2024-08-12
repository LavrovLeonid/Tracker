//
//  TrackerCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/28/24.
//

import Foundation

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func trackerCellComplete(cell: TrackerCollectionViewCell)
}
