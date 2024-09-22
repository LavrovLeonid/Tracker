//
//  CategoriesDataStore.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import CoreData
import UIKit

final class CategoriesDataStore: NSObject, CategoriesDataStoreProtocol {
    // MARK: Singleton
    static let shared: CategoriesDataStoreProtocol = CategoriesDataStore()
    private override init() {
        super.init()
    }
    
    @Multicast var delegate: CategoriesDataStoreDelegate
    
    private var context = PersistentContainer.shared.context
    private let pinCategoryName = NSLocalizedString("categoriesPinCategory", comment: "Pin category")
    private let dataStoreUpdates = DataStoreUpdates()
    
    private(set) lazy var pinCategory: TrackerCategoryEntity = {
        if let trackerCategoryEntity = fetchTrackerCategoryEntityBy(name: pinCategoryName) {
            return trackerCategoryEntity
        }
        
        let trackerCategoryEntity = TrackerCategoryEntity(context: context)
        
        trackerCategoryEntity.id = UUID()
        trackerCategoryEntity.name = pinCategoryName
        trackerCategoryEntity.isPinned = true
        
        contextSave()
        
        return trackerCategoryEntity
    }()
    
    private lazy var categoriesFetchedResultsController = {
        let fetchRequest = TrackerCategoryEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryEntity.name, ascending: true)
        ]
        
        fetchRequest.predicate = NSPredicate(
            format: "%K != %@",
            #keyPath(TrackerCategoryEntity.name),
            pinCategoryName as CVarArg
        )
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        
        try? controller.performFetch()
        
        return controller
    }()
    
    var categoriesCount: Int {
        categoriesFetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    var isEmptyCategories: Bool {
        categoriesCount == 0
    }
    
    func category(at indexPath: IndexPath) -> TrackerCategory {
        format(categoriesFetchedResultsController.object(at: indexPath))
    }
    
    func addCategory(_ category: TrackerCategory) {
        let trackerCategoryEntity = TrackerCategoryEntity(context: context)
        
        trackerCategoryEntity.id = category.id
        trackerCategoryEntity.name = category.name
        
        contextSave()
    }
    
    func editCategory(_ category: TrackerCategory) {
        guard let categoryEntity = fetchTrackerCategoryEntityBy(id: category.id) else { return }
        
        categoryEntity.name = category.name
        
        contextSave()
        
        $delegate.invoke { delegate in
            delegate.editCategory(category)
        }
    }
    
    func removeCategory(at indexPath: IndexPath) {
        let trackerCategoryEntity = categoriesFetchedResultsController.object(at: indexPath)
        
        context.delete(trackerCategoryEntity)
        
        contextSave()
    }
    
    func hasCategory(with name: String) -> Bool {
        guard pinCategory.name != name else { return true }
        
        return categoriesFetchedResultsController.fetchedObjects?.contains {
            $0.name == name
        } ?? false
    }
    
    func fetchTrackerCategoryEntityBy(name: String) -> TrackerCategoryEntity? {
        let fetchRequest = TrackerCategoryEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryEntity.name),
            name as CVarArg
        )
        
        return try? context.fetch(fetchRequest).first
    }
    
    func fetchTrackerCategoryEntityBy(id: TrackerCategoryId) -> TrackerCategoryEntity? {
        let fetchRequest = TrackerCategoryEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )
        
        return try? context.fetch(fetchRequest).first
    }
    
    func format(_ trackerCategoryEntity: TrackerCategoryEntity) -> TrackerCategory {
        TrackerCategory(
            id: trackerCategoryEntity.id ?? UUID(),
            name: trackerCategoryEntity.name ?? "",
            trackers: []
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

extension CategoriesDataStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        $delegate.invoke { delegate in
            delegate.didUpdate(with: dataStoreUpdates)
        }
        
        dataStoreUpdates.reset()
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
