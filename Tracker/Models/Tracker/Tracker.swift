//
//  Tracker.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import UIKit

struct Tracker: Identifiable {
    let id: TrackerId
    let type: TrackerType
    let name: String
    let color: UIColor
    let emoji: String
    let isPinned: Bool
    let schedules: Set<WeekDay>
}
