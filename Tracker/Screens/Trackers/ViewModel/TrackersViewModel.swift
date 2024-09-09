//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

final class TrackersViewModel: TrackersViewModelProtocol {
    private var trackersDataStore: DataStoreProtocol
    
    var onTrackersStateChange: Binding<Bool>?
    
    var numberOfSections: Int {
        trackersDataStore.numberOfSections
    }
    
    init(dataStore: DataStoreProtocol) {
        trackersDataStore = dataStore
        
        trackersDataStore.setDelegate(self)
    }
    
    func viewDidLoad() {
        onTrackersStateChange?(trackersDataStore.isEmptyTrackerCateogries)
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        trackersDataStore.numberOfItemsInSection(section)
    }
    
    @IBAction func setCurrentDate(_ date: Date) {
        trackersDataStore.setCurrentDate(date)
    }
    
    func addTrackerToCategory(_ category: TrackerCategory, tracker: Tracker) {
        trackersDataStore.addTrackerToCategory(category, tracker: tracker)
    }
    
    func categoryTitle(at section: Int) -> String {
        trackersDataStore.category(at: section).name
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

extension TrackersViewModel: DataStoreDelegate {
    func didUpdate() {
        onTrackersStateChange?(trackersDataStore.isEmptyTrackerCateogries)
    }
}
