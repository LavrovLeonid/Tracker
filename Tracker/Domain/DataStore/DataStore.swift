//
//  DataStore.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/24/24.
//

import CoreData
import UIKit

final class DataStore: NSObject, DataStoreProtocol {
    private var context: NSManagedObjectContext
    
    private let calendar = Calendar.current
    private var currentDate = Date()
    private var currentWeekday: WeekDay {
        WeekDay(
            rawValue: calendar.dateComponents(
                [.weekday],
                from: currentDate).weekday ?? 1
        ) ?? .monday
    }
    
    private lazy var trackerCategoriesFetchedResultsController = {
        let fetchRequest = TrackerCategoryEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryEntity.name, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        try? controller.performFetch()
        
        return controller
    }()
    
    private lazy var trackerRecordsFetchedResultsController = {
        let fetchRequest = TrackerRecordEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordEntity.trackerId, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        try? controller.performFetch()
        
        return controller
    }()
    
    private var trackerCategories: [TrackerCategory] {
        guard 
            let objects = self.trackerCategoriesFetchedResultsController.fetchedObjects
        else { return [] }
        
        return objects.compactMap { category in
            let trackers: [Tracker] = category.trackers?.array.compactMap { entity in
                guard let trackerEntity = entity as? TrackerEntity else { return nil }
                
                return try? format(from: trackerEntity)
            } ?? []
            
            let filteredTrackers = trackers.filter { tracker in
                tracker.type == .event || tracker.schedules.contains(currentWeekday)
            }
            
            guard !filteredTrackers.isEmpty else { return nil }
            
            return TrackerCategory(
                name: category.name ?? "",
                trackers: filteredTrackers
            )
        }
    }
    
    private weak var delegate: DataStoreDelegate?
    
    var isEmptyTrackerCateogries: Bool {
        trackerCategories.isEmpty
    }
    
    var numberOfSections: Int {
        trackerCategories.count
    }
    
    convenience init(delegate: DataStoreDelegate?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.init(delegate: delegate)
            
            return
        }
        
        self.init(context: appDelegate.persistentContainer.viewContext, delegate: delegate)
    }
    
    init(context: NSManagedObjectContext, delegate: DataStoreDelegate?) {
        self.context = context
        self.delegate = delegate
        
        super.init()
        
        trackerCategoriesFetchedResultsController.delegate = self
        trackerRecordsFetchedResultsController.delegate = self
    }
    
    func setCurrentDate(_ date: Date) {
        self.currentDate = date
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        trackerCategories[section].trackers.count
    }
    
    func category(at index: Int) -> TrackerCategory {
        trackerCategories[index]
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker {
        trackerCategories[indexPath.section].trackers[indexPath.item]
    }
    
    func countTrackerRecords(for tracker: Tracker) -> Int {
        guard let trackerEntity = try? fetchTrackerEntity(at: tracker) else { return 0 }
        guard let records = trackerEntity.records else { return 0 }
        
        return records.count
    }
    
    func isSelectedTracker(at tracker: Tracker) -> Bool {
        guard let trackerEntity = try? fetchTrackerEntity(at: tracker) else { return false }
        guard let records = trackerEntity.records else { return false }
        
        return records.contains { record in
            if let record = record as? TrackerRecordEntity, let date = record.date {
                return calendar.dateComponents([.day], from: currentDate).day == calendar.dateComponents([.day], from: date).day
            }
            
            return false
        }
    }
    
    func addCategory(_ category: TrackerCategory) {
        let trackerCategoryEntity = TrackerCategoryEntity(context: context)
        
        trackerCategoryEntity.name = category.name
        
        contextSave()
    }
    
    func addTrackerToCategory(_ trackerCategory: TrackerCategory, tracker: Tracker) {
        let trackerEntity = createTrackerEntity(tracker)
        
        if let trackerCategoryEntity = trackerCategoriesFetchedResultsController.fetchedObjects?.first(where: {
            trackerCategory.name == $0.name
        }) {
            trackerCategoryEntity.addToTrackers(trackerEntity)
        } else {
            let trackerCategoryEntity = TrackerCategoryEntity(context: context)
            
            trackerCategoryEntity.name = trackerCategory.name
            trackerCategoryEntity.addToTrackers(trackerEntity)
        }
        
        contextSave()
    }
    
    func completeTracker(at indexPath: IndexPath) {
        guard
            let trackerEntity = try? fetchTrackerEntity(
                at: trackerCategories[indexPath.section].trackers[indexPath.item]
            )
        else { return }
        
        if let trackerEntityRecord = fetchTrackerRecordEntity(at: trackerEntity) {
            trackerEntity.removeFromRecords(trackerEntityRecord)
        } else {
            let second = calendar.dateComponents([.second], from: Date(), to: currentDate).second ?? 0
            
            guard calendar.isDateInToday(currentDate) || second < 0 else { return }
            
            let trackerRecordEntity = TrackerRecordEntity(context: context)
            
            trackerRecordEntity.trackerId = trackerEntity.id
            trackerRecordEntity.date = currentDate
            
            trackerEntity.addToRecords(trackerRecordEntity)
        }
        
        contextSave()
    }
    
    func removeTracker(at indexPath: IndexPath) {
        guard 
            let trackerCategoryEntity = try? fetchTrackerCategoryEntity(at: trackerCategories[indexPath.section]),
            let trackerEntity = try? fetchTrackerEntity(at: trackerCategories[indexPath.section].trackers[indexPath.item])
        else { return }
        
        trackerCategoryEntity.removeFromTrackers(trackerEntity)
        
        contextSave()
    }
    
    private func createTrackerEntity(_ tracker: Tracker) -> TrackerEntity {
        let trackerEntity = TrackerEntity(context: context)
        
        trackerEntity.schedules = Set(tracker.schedules.map(\.rawValue))
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.color = tracker.color.hexString()
        trackerEntity.emoji = tracker.emoji
        trackerEntity.type = Int16(tracker.type.rawValue)
        
        return trackerEntity
    }
    
    private func fetchTrackerCategoryEntity(
        at trackerCategory: TrackerCategory
    ) throws -> TrackerCategoryEntity {
        let fetchRequest = TrackerCategoryEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "name == %@",
            trackerCategory.name as CVarArg
        )
        
        guard let trackerCategoryEntity = try context.fetch(fetchRequest).first else {
            throw DataStoreError.notFoundCategory
        }
        
        return trackerCategoryEntity
    }
    
    private func fetchTrackerEntity(at tracker: Tracker) throws -> TrackerEntity {
        let fetchRequest = TrackerEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "id == %@",
            tracker.id as CVarArg
        )
        
        guard let trackerEntitiy = try context.fetch(fetchRequest).first else {
            throw DataStoreError.notFoundCategory
        }
        
        return trackerEntitiy
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
    
    private func format(from trackerEntity: TrackerEntity) throws -> Tracker {
        guard
            let id = trackerEntity.id,
            let hexColor = trackerEntity.color,
            let color = UIColor(hex: hexColor)
        else { throw DataStoreError.trackerDecodingError }
        
        let type = TrackerType(rawValue: Int(trackerEntity.type)) ?? .habit
        let schedules = trackerEntity.schedules?.compactMap { WeekDay(rawValue: $0) } ?? []
        
        return Tracker(
            id: id,
            type: type,
            name: trackerEntity.name ?? "",
            color: color,
            emoji: trackerEntity.emoji ?? "",
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

extension DataStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
