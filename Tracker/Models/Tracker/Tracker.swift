//
//  Tracker.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import Foundation

struct Tracker: Identifiable {
    let id: TrackerId
    let type: TrackerType
    let name: String
    let color: TrackerColor
    let emoji: String
    let schedules: Set<WeekDay>
}
