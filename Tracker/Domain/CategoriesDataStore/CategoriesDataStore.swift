//
//  CategoriesDataStore.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import CoreData
import UIKit

final class CategoriesDataStore: NSObject, CategoriesDataStoreProtocol {
    private var context: NSManagedObjectContext
    
    private var insertedIndexes = IndexSet()
    private var deletedIndexes = IndexSet()
    private var updatedIndexes = IndexSet()
    
    private lazy var categoriesFetchedResultsController = {
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
    
    private var categories: [TrackerCategory] {
        guard
            let objects = self.categoriesFetchedResultsController.fetchedObjects
        else { return [] }
        
        return objects.compactMap { category in
            TrackerCategory(
                id: category.id ?? UUID(),
                name: category.name ?? "",
                trackers: []
            )
        }
    }
    
    weak var delegate: CategoriesDataStoreDelegate?
    
    var isEmptyCategories: Bool {
        categoriesFetchedResultsController.sections?.isEmpty ?? true
    }
    
    var categoriesCount: Int {
        categoriesFetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    convenience init(delegate: CategoriesDataStoreDelegate? = nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.init(delegate: delegate)
            
            return
        }
        
        self.init(context: appDelegate.persistentContainer.viewContext, delegate: delegate)
    }
    
    init(context: NSManagedObjectContext, delegate: CategoriesDataStoreDelegate?) {
        self.context = context
        self.delegate = delegate
        
        super.init()
        
        categoriesFetchedResultsController.delegate = self
    }
    
    func category(at index: Int) -> TrackerCategory {
        categories[index]
    }
    
    func addCategory(_ category: TrackerCategory) {
        let trackerCategoryEntity = TrackerCategoryEntity(context: context)
        
        trackerCategoryEntity.id = category.id
        trackerCategoryEntity.name = category.name
        
        contextSave()
    }
    
    func removeCategory(_ category: TrackerCategory) {
        guard
            let categoryEntity = fetchTrackerCategoryEntity(at: category)
        else { return }
        
        context.delete(categoryEntity)
        
        contextSave()
    }
    
    func editCategory(_ category: TrackerCategory) {
        guard
            let categoryEntity = fetchTrackerCategoryEntity(at: category)
        else { return }
        
        categoryEntity.name = category.name
        
        contextSave()
    }
    
    func hasCategory(with name: String) -> Bool {
        categories.contains { $0.name == name }
    }
    
    private func fetchTrackerCategoryEntity(
        at trackerCategory: TrackerCategory
    ) -> TrackerCategoryEntity? {
        let fetchRequest = TrackerCategoryEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "id == %@",
            trackerCategory.id as CVarArg
        )
        
        return try? context.fetch(fetchRequest).first
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
        delegate?.didUpdate(
            with: DataStoreUpdates(
                insertedIndexes: insertedIndexes,
                updatedIndexes: updatedIndexes,
                deletedIndexes: deletedIndexes
            )
        )
        
        insertedIndexes.removeAll()
        updatedIndexes.removeAll()
        deletedIndexes.removeAll()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
            case .insert:
                if let newIndexPath {
                    insertedIndexes.insert(newIndexPath.item)
                }
            case .delete:
                if let indexPath {
                    deletedIndexes.insert(indexPath.item)
                }
            case .move:
                break
            case .update:
                if let indexPath {
                    updatedIndexes.insert(indexPath.item)
                }
            default:
                break
        }
    }
}
