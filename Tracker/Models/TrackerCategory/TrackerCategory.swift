//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import Foundation

struct TrackerCategory: Identifiable, Equatable {
    let id: TrackerCategoryId
    let name: String
    let trackers: [Tracker]
    
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.id == rhs.id
    }
}
