//
//  TrackersDataStoreProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/29/24.
//

import Foundation

protocol TrackersDataStoreProtocol: NSObjectProtocol {
    var isEmptyTrackerCategories: Bool { get }
    var searchText: String { get }
    var appliedFilter: TrackersFilter { get }
    var numberOfSections: Int { get }
    var delegate: TrackersDataStoreDelegate? { get set }
    
    func fetchTrackers()
    func setDate(_ date: Date)
    func setSearchText(_ searchText: String)
    func setFilter(_ filter: TrackersFilter)
    func resetDate()
    func numberOfItemsInSection(_ section: Int) -> Int
    func category(at indexPath: IndexPath) -> TrackerCategory
    func originCategory(at indexPath: IndexPath) -> TrackerCategory
    func tracker(at indexPath: IndexPath) -> Tracker
    func countTrackerRecords(at indexPath: IndexPath) -> Int
    func isPinnedTracker(at indexPath: IndexPath) -> Bool
    func isCompletedTracker(at indexPath: IndexPath) -> Bool
    func addTracker(_ tracker: Tracker, to category: TrackerCategory)
    func editTracker(_ tracker: Tracker, at category: TrackerCategory)
    func completeTracker(at indexPath: IndexPath)
    func uncompleteTracker(at indexPath: IndexPath)
    func removeTracker(at indexPath: IndexPath)
    func pinTracker(at indexPath: IndexPath)
    func unpinTracker(at indexPath: IndexPath)
}
