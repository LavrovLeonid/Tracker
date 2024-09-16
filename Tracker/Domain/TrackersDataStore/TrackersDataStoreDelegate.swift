//
//  TrackersDataStoreDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/25/24.
//

import Foundation

protocol TrackersDataStoreDelegate: AnyObject {
    func didUpdate(with updates: DataStoreUpdatesPropertiesProtocol)
}
