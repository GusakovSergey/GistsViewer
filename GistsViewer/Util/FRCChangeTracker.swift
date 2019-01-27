//
//  FRCChangeTracker.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import UIKit
import CoreData

//MARK: - Types
struct FRCChangeTrackerTypes {
    private init() {}
    
    struct FRCChange<U> {
        let type: NSFetchedResultsChangeType
        let oldIndexPath: IndexPath?
        let newIndexPath: IndexPath?
        let object: U
    }
    
    class FRCBatch<U> {
        private(set) var insertedChanges = [FRCChange<U>]()
        private(set) var deletedChanges = [FRCChange<U>]()
        private(set) var updatedChanges = [FRCChange<U>]()
        private(set) var movedTChanges = [FRCChange<U>]()
        
        public func addChange(_ change: FRCChange<U>) {
            switch change.type {
            case .insert:
                insertedChanges.append(change)
            case .delete:
                deletedChanges.append(change)
            case .move:
                movedTChanges.append(change)
            case .update:
                updatedChanges.append(change)
            }
        }
    }
}

class FRCChangeTracker<T: NSManagedObject, U>: NSObject, NSFetchedResultsControllerDelegate {
    typealias FRCBatch = FRCChangeTrackerTypes.FRCBatch
    typealias FRCChange = FRCChangeTrackerTypes.FRCChange
    
    //MARK: - Properties
    let fetchedResultsController: NSFetchedResultsController<T>
    var didChangeHandler: ((FRCBatch<U>)->())?
    
    private var batch: FRCBatch<U>?
    private let cast: (T)->(U)
    
    init(fetchedResultsController: NSFetchedResultsController<T>,
         cast: @escaping (T)->(U)) {
        self.cast = cast
        self.fetchedResultsController = fetchedResultsController
        super.init()
        
        fetchedResultsController.delegate = self
    }
    
    func modelFor(indexPath: IndexPath) -> U {
        return cast(fetchedResultsController.object(at: indexPath))
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        batch = FRCBatch()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let plainObject = cast(anObject as! T)
        let change = FRCChange(type: type,
                               oldIndexPath: indexPath,
                               newIndexPath: newIndexPath,
                               object: plainObject)
        batch?.addChange(change)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let batch = batch {
            didChangeHandler?(batch)
            self.batch = nil
        }
    }
}

extension UITableView {
    func processChangeTrackerBatch<T>(_ batch: FRCChangeTrackerTypes.FRCBatch<T>,
                                      updateCellBlock:(IndexPath, T)->(),
                                      rowAnimation: UITableView.RowAnimation = .automatic) {
        self.beginUpdates()
        
        let insertedIndexPaths = batch.insertedChanges.compactMap({$0.newIndexPath})
        if insertedIndexPaths.count > 0 {
            insertRows(at: insertedIndexPaths, with: rowAnimation)
        }
        
        let deletedPaths = batch.deletedChanges.compactMap({$0.oldIndexPath})
        if deletedPaths.count > 0 {
            deleteRows(at: deletedPaths, with: rowAnimation)
        }
        
        batch.movedTChanges.forEach { (transaction) in
            if let oldIndexPath = transaction.oldIndexPath {
                updateCellBlock(oldIndexPath, transaction.object)
                if let newIndexPath = transaction.newIndexPath, newIndexPath.row != oldIndexPath.row {
                    moveRow(at: oldIndexPath, to: newIndexPath)
                }
            }
        }
        
        batch.updatedChanges.forEach { (transaction) in
            updateCellBlock(transaction.oldIndexPath!, transaction.object)
            if let newIndexPath = transaction.newIndexPath, newIndexPath != transaction.oldIndexPath! {
                updateCellBlock(newIndexPath, transaction.object)
            }
        }
        
        self.endUpdates()
    }
}
