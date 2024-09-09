//
//  TrackersViewModelProtocol.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import Foundation

protocol TrackersViewModelProtocol {
    // MARK: Bindings
    var onTrackersStateChange: Binding<Bool>? { get set }
    
    // MARK: Properties
    var numberOfSections: Int { get }
    
    // MARK: Methods
    func viewDidLoad()
    func numberOfItemsInSection(_ section: Int) -> Int
    func categoryTitle(at section: Int) -> String
    func tracker(at indexPath: IndexPath) -> Tracker
    func countTrackerRecords(for tracker: Tracker) -> Int
    func isSelectedTracker(at tracker: Tracker) -> Bool
    func setCurrentDate(_ date: Date)
    func addTrackerToCategory(_ category: TrackerCategory, tracker: Tracker)
    func removeTracker(at indexPath: IndexPath)
    func completeTracker(at indexPath: IndexPath)
}
