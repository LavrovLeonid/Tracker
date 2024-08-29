//
//  DataStoreProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/29/24.
//

import Foundation

protocol DataStoreProtocol: NSObjectProtocol {
    var isEmptyTrackerCateogries: Bool { get }
    var numberOfSections: Int { get }
    
    func setCurrentDate(_ date: Date)
    func numberOfItemsInSection(_ section: Int) -> Int
    func category(at index: Int) -> TrackerCategory
    func tracker(at indexPath: IndexPath) -> Tracker
    func countTrackerRecords(for tracker: Tracker) -> Int
    func isSelectedTracker(at tracker: Tracker) -> Bool
    func addCategory(_ category: TrackerCategory)
    func addTrackerToCategory(_ trackerCategory: TrackerCategory, tracker: Tracker)
    func completeTracker(at indexPath: IndexPath)
    func removeTracker(at indexPath: IndexPath)
}
