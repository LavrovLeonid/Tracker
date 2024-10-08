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
    var onTrackersStateChange: Binding<DataStoreUpdatesPropertiesProtocol>?
    var onTrackersPresentEmptyView: BindingWithoutValue?
    var onTrackersPresentNotFoundView: BindingWithoutValue?
    var onTrackersReloadCollectionView: BindingWithoutValue?
    var onTrackersPresentCollectionView: BindingWithoutValue?
    var onTrackersSetDate: Binding<Date>?
    
    // MARK: Properties
    var numberOfSections: Int {
        trackersDataStore.numberOfSections
    }
    
    var appliedFilter: TrackersFilter {
        trackersDataStore.appliedFilter
    }
    
    // MARK: Initialization
    init(dataStore: TrackersDataStoreProtocol) {
        trackersDataStore = dataStore
        
        trackersDataStore.delegate = self
    }
    
    // MARK: Methods
    func viewDidLoad() {
        if trackersDataStore.isEmptyTrackerCategories {
            onTrackersPresentEmptyView?()
        } else {
            onTrackersPresentCollectionView?()
            onTrackersReloadCollectionView?()
        }
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        trackersDataStore.numberOfItemsInSection(section)
    }
    
    func setCurrentDate(_ date: Date) {
        trackersDataStore.setDate(date)
        
        trackersDataStore.fetchTrackers()
        
        updateView()
    }
    
    func setSearchText(_ searchText: String) {
        trackersDataStore.setSearchText(searchText)
        
        trackersDataStore.fetchTrackers()
        
        updateView()
    }
    
    func setFilter(_ filter: TrackersFilter) {
        trackersDataStore.setFilter(filter)
        
        if case .today = filter {
            trackersDataStore.resetDate()
        }
        
        trackersDataStore.fetchTrackers()
        
        updateView()
    }
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) {
        trackersDataStore.resetDate()
        
        trackersDataStore.addTracker(tracker, to: category)
    }
    
    func editTracker(_ tracker: Tracker, at category: TrackerCategory) {
        trackersDataStore.editTracker(tracker, at: category)
    }
    
    func category(at section: Int) -> TrackerCategory {
        trackersDataStore.category(at: IndexPath(item: 0, section: section))
    }
    
    func originCategory(at indexPath: IndexPath) -> TrackerCategory {
        trackersDataStore.originCategory(at: indexPath)
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker {
        trackersDataStore.tracker(at: indexPath)
    }
    
    func countTrackerRecords(at indexPath: IndexPath) -> Int {
        trackersDataStore.countTrackerRecords(at: indexPath)
    }
    
    func isCompletedTracker(at indexPath: IndexPath) -> Bool {
        trackersDataStore.isCompletedTracker(at: indexPath)
    }
    
    func removeTracker(at indexPath: IndexPath) {
        trackersDataStore.removeTracker(at: indexPath)
    }
    
    func completeTrackerTapped(at indexPath: IndexPath) {
        if trackersDataStore.isCompletedTracker(at: indexPath) {
            trackersDataStore.uncompleteTracker(at: indexPath)
        } else {
            trackersDataStore.completeTracker(at: indexPath)
        }
    }
    
    func didFinishUpdates() {
        if trackersDataStore.isEmptyTrackerCategories {
            if trackersDataStore.searchText.isEmpty {
                onTrackersPresentEmptyView?()
            } else {
                onTrackersPresentNotFoundView?()
            }
        } else {
            onTrackersPresentCollectionView?()
        }
    }
    
    func isPinnedTracker(at indexPath: IndexPath) -> Bool {
        trackersDataStore.isPinnedTracker(at: indexPath)
    }
    
    func pinTrackerTapped(at indexPath: IndexPath) {
        if trackersDataStore.isPinnedTracker(at: indexPath) {
            trackersDataStore.unpinTracker(at: indexPath)
        } else {
            trackersDataStore.pinTracker(at: indexPath)
        }
    }
    
    private func updateView() {
        onTrackersReloadCollectionView?()
        
        if trackersDataStore.isEmptyTrackerCategories {
            if trackersDataStore.searchText.isEmpty {
                switch trackersDataStore.appliedFilter {
                    case .completed, .notCompleted:
                        onTrackersPresentNotFoundView?()
                    default:
                        onTrackersPresentEmptyView?()
                }
            } else {
                onTrackersPresentNotFoundView?()
            }
        } else {
            onTrackersPresentCollectionView?()
        }
    }
}

// MARK: DataStoreDelegate
extension TrackersViewModel: TrackersDataStoreDelegate {
    func didUpdate(with updates: DataStoreUpdatesPropertiesProtocol) {
        onTrackersStateChange?(updates)
    }
}
