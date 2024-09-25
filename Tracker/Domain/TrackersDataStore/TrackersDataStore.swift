//
//  TrackersDataStore.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/24/24.
//

import CoreData
import UIKit

final class TrackersDataStore: NSObject, TrackersDataStoreProtocol {
    private var context = PersistentContainer.shared.context
    private let categoriesDataStore = CategoriesDataStore.shared
    private let calendar = Calendar.current
    
    private let today = Date()
    
    let dataStoreUpdates = DataStoreUpdates()
    
    private(set) var searchText = ""
    private(set) var appliedFilter: TrackersFilter = .all
    
    private lazy var currentDate: Date = {
        today
    }()
    private var startOfDay: Date {
        calendar.startOfDay(for: currentDate)
    }
    
    private var endOfDay: Date {
        var components = DateComponents()
        
        components.day = 1
        components.second = -1
        
        return calendar.date(byAdding: components, to: startOfDay) ?? Date()
    }
    
    private var currentWeekday: WeekDay {
        WeekDay(
            rawValue: calendar.dateComponents(
                [.weekday],
                from: currentDate).weekday ?? 1
        ) ?? .monday
    }
    
    private lazy var trackersFetchedResultsController = {
        let fetchRequest = TrackerEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(
                key: #keyPath(TrackerEntity.sectionCategory.isPinned),
                ascending: false
            )
        ]
        
        fetchRequest.predicate = getTrackersPredicate()
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "sectionCategory.id",
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }()
    
    private var trackersSections: [NSFetchedResultsSectionInfo] {
        trackersFetchedResultsController.sections ?? []
    }
    
    weak var delegate: TrackersDataStoreDelegate?
    
    var isEmptyTrackerCategories: Bool {
        trackersSections.isEmpty
    }
    
    var numberOfSections: Int {
        trackersSections.count
    }
    
    override init() {
        super.init()
        
        categoriesDataStore.delegate = self
    }
    
    func fetchTrackers() {
        trackersFetchedResultsController.fetchRequest.predicate = getTrackersPredicate()
        
        try? trackersFetchedResultsController.performFetch()
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        trackersSections[section].numberOfObjects
    }
    
    func category(at indexPath: IndexPath) -> TrackerCategory {
        let section = trackersSections[indexPath.section]
        
        guard
            let category = categoriesDataStore.fetchTrackerCategoryEntityBy(id: UUID(uuidString: section.name) ?? UUID())
        else { return TrackerCategory(id: UUID(), name: section.name, trackers: []) }
        
        return categoriesDataStore.format(category)
    }
    
    func originCategory(at indexPath: IndexPath) -> TrackerCategory {
        let trackerEntity = trackersFetchedResultsController.object(at: indexPath)
        
        guard let originCategory = trackerEntity.originCategory else {
            return TrackerCategory(id: UUID(), name: "", trackers: [])
        }
        
        return categoriesDataStore.format(originCategory)
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker {
        let trackerEntity = trackersFetchedResultsController.object(at: indexPath)
        
        return format(from: trackerEntity)
    }
    
    func countTrackerRecords(at indexPath: IndexPath) -> Int {
        let trackerEntity = trackersFetchedResultsController.object(at: indexPath)
        
        guard let records = trackerEntity.records else { return 0 }
        
        return records.count
    }
    
    func isCompletedTracker(at indexPath: IndexPath) -> Bool {
        let trackerEntity = trackersFetchedResultsController.object(at: indexPath)
        
        guard let records = trackerEntity.records else { return false }
        
        return records.contains { record in
            if let record = record as? TrackerRecordEntity, let date = record.date {
                return calendar.dateComponents([.day], from: currentDate).day == calendar.dateComponents([.day], from: date).day
            }
            
            return false
        }
    }
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) {
        let trackerEntity = createTrackerEntity(tracker)
        
        guard
            let trackerCategoryEntity = categoriesDataStore.fetchTrackerCategoryEntityBy(id: category.id)
        else { return }
        
        trackerEntity.originCategory = trackerCategoryEntity
        trackerEntity.sectionCategory = trackerCategoryEntity
        
        contextSave()
    }
    
    func editTracker(_ tracker: Tracker, at category: TrackerCategory) {
        guard let trackerEntity = fetchTrackerEntityBy(id: tracker.id) else { return }
        
        trackerEntity.name = tracker.name
        trackerEntity.color = tracker.color.hexString()
        trackerEntity.emoji = tracker.emoji
        trackerEntity.type = Int16(tracker.type.rawValue)
        trackerEntity.schedules = tracker.schedules.map { String($0.rawValue) }.joined(separator: ",")
        
        if let trackerCategoryEntity = categoriesDataStore.fetchTrackerCategoryEntityBy(id: category.id) {
            trackerEntity.originCategory = trackerCategoryEntity
        }
        
        contextSave()
    }
    
    func completeTracker(at indexPath: IndexPath) {
        let trackerEntity = trackersFetchedResultsController.object(at: indexPath)
        
        let second = calendar.dateComponents([.second], from: Date(), to: currentDate).second ?? 0
        
        guard calendar.isDateInToday(currentDate) || second < 0 else { return }
        
        let trackerRecordEntity = TrackerRecordEntity(context: context)
        
        trackerRecordEntity.trackerId = trackerEntity.id
        trackerRecordEntity.date = currentDate
        
        trackerEntity.addToRecords(trackerRecordEntity)
        
        contextSave()
    }
    
    func uncompleteTracker(at indexPath: IndexPath) {
        let trackerEntity = trackersFetchedResultsController.object(at: indexPath)
        
        guard let trackerRecordEntity = fetchTrackerRecordEntity(at: trackerEntity) else { return }
        
        trackerEntity.removeFromRecords(trackerRecordEntity)
        
        context.delete(trackerRecordEntity)
        
        contextSave()
    }
    
    func removeTracker(at indexPath: IndexPath) {
        context.delete(trackersFetchedResultsController.object(at: indexPath))
        
        contextSave()
    }
    
    func setDate(_ date: Date) {
        self.currentDate = date
    }
    
    func resetDate() {
        self.currentDate = today
    }
    
    func setSearchText(_ searchText: String) {
        self.searchText = searchText
    }
    
    func setFilter(_ filter: TrackersFilter) {
        self.appliedFilter = filter
    }
    
    func isPinnedTracker(at indexPath: IndexPath) -> Bool {
        let trackerEntity = trackersFetchedResultsController.object(at: indexPath)
        
        return trackerEntity.sectionCategory == categoriesDataStore.pinCategory
    }
    
    func pinTracker(at indexPath: IndexPath) {
        let trackerEntity = trackersFetchedResultsController.object(at: indexPath)
        
        trackerEntity.sectionCategory = categoriesDataStore.pinCategory
        
        contextSave()
    }
    
    func unpinTracker(at indexPath: IndexPath) {
        let trackerEntity = trackersFetchedResultsController.object(at: indexPath)
        
        trackerEntity.sectionCategory = trackerEntity.originCategory
        
        contextSave()
    }
    
    private func getTrackersPredicate() -> NSCompoundPredicate {
        let typePredicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerEntity.type),
            NSNumber(value: TrackerType.event.rawValue)
        )
        let weekDayPredicate = NSPredicate(
            format: "%K CONTAINS %@",
            #keyPath(TrackerEntity.schedules),
            NSString(string: String(currentWeekday.rawValue))
        )
        
        let predicates: [NSPredicate] = [typePredicate, weekDayPredicate]
        
        var filterPredicate: NSPredicate?
        
        switch appliedFilter {
            case .completed:
                filterPredicate = NSPredicate(
                    format: "SUBQUERY(records, $record, $record.date BETWEEN {%@, %@}).@count > 0",
                    startOfDay as NSDate,
                    endOfDay as NSDate
                )
            case .notCompleted:
                filterPredicate = NSPredicate(
                    format: "SUBQUERY(records, $record, $record.date BETWEEN {%@, %@}).@count == 0",
                    startOfDay as NSDate,
                    endOfDay as NSDate
                )
            default:
                break
        }
        
        let compoundPredicate = NSCompoundPredicate(
            orPredicateWithSubpredicates: predicates
        )
        
        guard !searchText.isEmpty else {
            if let filterPredicate {
                return NSCompoundPredicate(
                    andPredicateWithSubpredicates: [compoundPredicate, filterPredicate]
                )
            } else {
                return compoundPredicate
            }
        }
        
        let searchNamePredicate = NSPredicate(
            format: "%K CONTAINS[c] %@",
            #keyPath(TrackerEntity.name),
            NSString(string: searchText.lowercased())
        )
        
        if let filterPredicate {
            return NSCompoundPredicate(
                andPredicateWithSubpredicates: [compoundPredicate, filterPredicate, searchNamePredicate]
            )
        } else {
            return NSCompoundPredicate(
                andPredicateWithSubpredicates: [compoundPredicate, searchNamePredicate]
            )
        }
    }
    
    private func createTrackerEntity(_ tracker: Tracker) -> TrackerEntity {
        let trackerEntity = TrackerEntity(context: context)
        
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.color = tracker.color.hexString()
        trackerEntity.emoji = tracker.emoji
        trackerEntity.type = Int16(tracker.type.rawValue)
        trackerEntity.schedules = tracker.schedules.map {
            String($0.rawValue)
        }.joined(separator: ",")
        
        return trackerEntity
    }
    
    private func fetchTrackerEntityBy(id: TrackerId) -> TrackerEntity? {
        let fetchRequest = TrackerEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )
        
        return try? context.fetch(fetchRequest).first
    }
    
    private func fetchTrackerRecordEntity(at trackerEntity: TrackerEntity) -> TrackerRecordEntity? {
        guard let records = trackerEntity.records else { return nil }
        
        let record = records.allObjects.first(where: { record in
            if let record = record as? TrackerRecordEntity {
                return calendar.dateComponents([.day], from: currentDate).day ==
                calendar.dateComponents([.day], from: record.date ?? Date()).day
            }
            
            return false
        })
        
        return record as? TrackerRecordEntity
    }
    
    func format(from trackerEntity: TrackerEntity) -> Tracker {
        let type = TrackerType(rawValue: Int(trackerEntity.type)) ?? .habit
        let schedules = trackerEntity.schedules?
            .split(separator: ",")
            .compactMap { WeekDay(rawValue: Int($0) ?? 0) } ?? []
        
        return Tracker(
            id: trackerEntity.id ?? UUID(),
            type: type,
            name: trackerEntity.name ?? "",
            color: UIColor(hex: trackerEntity.color ?? "") ?? .trackerBlue,
            emoji: trackerEntity.emoji ?? "",
            isPinned: trackerEntity.sectionCategory?.isPinned ?? false,
            schedules: Set(schedules)
        )
    }
    
    private func contextSave() {
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения данных: ", error.localizedDescription)
        }
    }
}

extension TrackersDataStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        delegate?.didUpdate(with: dataStoreUpdates)
        
        dataStoreUpdates.reset()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        dataStoreUpdates.changeSections(for: type, at: sectionIndex)
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        dataStoreUpdates.changeItems(for: type, at: indexPath, newIndexPath: newIndexPath)
    }
}

extension TrackersDataStore: CategoriesDataStoreDelegate {
    func editCategory(_ category: TrackerCategory) {
        guard
            let sectionIndex = trackersSections.firstIndex(where: { $0.name == category.id.uuidString })
        else { return }
        
        dataStoreUpdates.changeSections(for: .update, at: sectionIndex)
        
        delegate?.didUpdate(with: dataStoreUpdates)
        
        dataStoreUpdates.reset()
    }
}
