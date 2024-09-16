//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

final class TrackersViewModel: TrackersViewModelProtocol {
    // MARK: Model
    private let trackersDataStore: TrackersDataStoreProtocol
    
    // MARK: Bindings
    var onTrackersStateChange: Binding<Bool>?
    
    // MARK: Properties
    var numberOfSections: Int {
        trackersDataStore.numberOfSections
    }
    
    // MARK: Initialization
    init(dataStore: TrackersDataStoreProtocol) {
        trackersDataStore = dataStore
        
        trackersDataStore.delegate = self
    }
    
    // MARK: Methods
    func viewDidLoad() {
        onTrackersStateChange?(trackersDataStore.isEmptyTrackerCateogries)
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        trackersDataStore.numberOfItemsInSection(section)
    }
    
    func setCurrentDate(_ date: Date) {
        trackersDataStore.setCurrentDate(date)
        
        onTrackersStateChange?(trackersDataStore.isEmptyTrackerCateogries)
    }
    
    func addTrackerToCategory(_ category: TrackerCategory, tracker: Tracker) {
        trackersDataStore.addTrackerToCategory(category, tracker: tracker)
    }
    
    func category(at section: Int) -> TrackerCategory {
        trackersDataStore.category(at: section)
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker {
        trackersDataStore.tracker(at: indexPath)
    }
    
    func countTrackerRecords(for tracker: Tracker) -> Int {
        trackersDataStore.countTrackerRecords(for: tracker)
    }
    
    func isSelectedTracker(at tracker: Tracker) -> Bool {
        trackersDataStore.isSelectedTracker(at: tracker)
    }
    
    func removeTracker(at indexPath: IndexPath) {
        trackersDataStore.removeTracker(at: indexPath)
    }
    
    func completeTracker(at indexPath: IndexPath) {
        trackersDataStore.completeTracker(at: indexPath)
    }
    
}

// MARK: DataStoreDelegate
extension TrackersViewModel: TrackersDataStoreDelegate {
    func didUpdate() {
        onTrackersStateChange?(trackersDataStore.isEmptyTrackerCateogries)
    }
}
