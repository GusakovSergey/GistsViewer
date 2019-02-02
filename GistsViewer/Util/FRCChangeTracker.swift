//
//  FRCChangeTracker.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import UIKit
import CoreData

class FRCChangeTracker<T: NSManagedObject, U>: ChangeTracker<U>, NSFetchedResultsControllerDelegate {
    typealias Batch = ChangeTracker<U>.Batch
    typealias Change = ChangeTracker<U>.Change
    
    //MARK: - Properties
    let fetchedResultsController: NSFetchedResultsController<T>
    
    private var batch: Batch<U>?
    private let cast: (T)->(U)
    
    init(fetchedResultsController: NSFetchedResultsController<T>,
         cast: @escaping (T)->(U)) {
        self.cast = cast
        self.fetchedResultsController = fetchedResultsController
        super.init()
        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    //MARK: - ChangeTracker
    override func sectionsCount() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func numberOfObjectsIn(section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func modelFor(indexPath: IndexPath) -> U {
        return cast(fetchedResultsController.object(at: indexPath))
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        batch = Batch()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let plainObject = cast(anObject as! T)
        let change = Change(type: type,
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
