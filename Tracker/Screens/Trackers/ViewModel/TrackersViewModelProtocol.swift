//
//  TrackersViewModelProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol TrackersViewModelProtocol {
    // MARK: Bindings
    var onTrackersStateChange: Binding<DataStoreUpdatesPropertiesProtocol>? { get set }
    var onTrackersPresentEmptyView: BindingWithoutValue? { get set }
    var onTrackersPresentNotFoundView: BindingWithoutValue? { get set }
    var onTrackersPresentCollectionView: BindingWithoutValue? { get set }
    var onTrackersReloadCollectionView: BindingWithoutValue? { get set }
    
    // MARK: Properties
    var numberOfSections: Int { get }
    
    // MARK: Methods
    func viewDidLoad()
    func numberOfItemsInSection(_ section: Int) -> Int
    func category(at section: Int) -> TrackerCategory
    func originCategory(at indexPath: IndexPath) -> TrackerCategory
    func tracker(at indexPath: IndexPath) -> Tracker
    func countTrackerRecords(at indexPath: IndexPath) -> Int
    func isCompletedTracker(at indexPath: IndexPath) -> Bool
    func isPinnedTracker(at indexPath: IndexPath) -> Bool
    func setCurrentDate(_ date: Date)
    func setSearchText(_ searchText: String)
    func addTracker(_ tracker: Tracker, to category: TrackerCategory)
    func editTracker(_ tracker: Tracker, at category: TrackerCategory)
    func removeTracker(at indexPath: IndexPath)
    func completeTrackerTapped(at indexPath: IndexPath)
    func didFinishUpdates()
    func pinTrackerTapped(at indexPath: IndexPath)
}
