//
//  ChangeTracker.swift
//  GistsViewer
//
//  Created by Sergey on 31/01/2019.
//

import UIKit
import CoreData

class ChangeTrackerBatch<U> {
    struct Change {
        let type: NSFetchedResultsChangeType
        let oldIndexPath: IndexPath?
        let newIndexPath: IndexPath?
        let object: U
    }
    private(set) var insertedChanges = [Change]()
    private(set) var deletedChanges = [Change]()
    private(set) var updatedChanges = [Change]()
    private(set) var movedTChanges = [Change]()
    var allChanges: [Change] {
        return insertedChanges + deletedChanges + updatedChanges + movedTChanges
    }
    
    public func addChange(_ change: Change) {
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
    
    func map<T>(block: (U)->(T)) -> ChangeTrackerBatch<T> {
        let batch = ChangeTrackerBatch<T>()
        allChanges.forEach({ (change) in
            let mappedObject: T = block(change.object)
            batch.addChange(ChangeTrackerBatch<T>.Change(type: change.type,
                                            oldIndexPath: change.oldIndexPath,
                                            newIndexPath: change.newIndexPath,
                                            object: mappedObject))
        })
        return batch
    }
}

class ChangeTracker<Model>: NSObject {
    //MARK: - Types
    
    
    //MARK: - Properties
    var didChangeHandler: ((ChangeTrackerBatch<Model>)->())?
    
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
    func processChangeTrackerBatch<T>(_ batch: ChangeTrackerBatch<T>,
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
