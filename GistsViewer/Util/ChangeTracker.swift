//
//  ChangeTracker.swift
//  GistsViewer
//
//  Created by Sergey on 31/01/2019.
//

import UIKit
import CoreData

class ChangeTracker<Model>: NSObject {
    //MARK: - Types
    struct Change<U> {
        let type: NSFetchedResultsChangeType
        let oldIndexPath: IndexPath?
        let newIndexPath: IndexPath?
        let object: U
    }
    
    class Batch<U> {
        private(set) var insertedChanges = [Change<U>]()
        private(set) var deletedChanges = [Change<U>]()
        private(set) var updatedChanges = [Change<U>]()
        private(set) var movedTChanges = [Change<U>]()
        
        public func addChange(_ change: Change<U>) {
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
    
    //MARK: - Properties
    var didChangeHandler: ((Batch<Model>)->())?
    
    //MARK: - Functions
    func sectionsCount() -> Int {
        fatalError("to override")
    }
    func numberOfObjectsIn(section: Int) -> Int {
        fatalError("to override")
    }
    func modelFor(indexPath: IndexPath) -> Model {
        fatalError("to override")
    }
}

extension UITableView {
    func processChangeTrackerBatch<T>(_ batch: ChangeTracker<T>.Batch<T>,
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
