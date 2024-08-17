//
//  ListItemCollectionCellDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/10/24.
//

import Foundation

protocol ListItemCollectionCellDelegate: AnyObject {
    func listItem(_ cell: ListItemCollectionViewCell, toggle isOn: Bool)
}
