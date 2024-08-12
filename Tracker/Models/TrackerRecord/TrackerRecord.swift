//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/27/24.
//

import Foundation

struct TrackerRecord: Hashable, Equatable {
    let trackerId: TrackerId
    let date: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackerId)
    }
    
    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
        lhs.trackerId == rhs.trackerId &&
        Calendar.current.dateComponents([.day], from: lhs.date).day ==
        Calendar.current.dateComponents([.day], from: rhs.date).day
    }
}
