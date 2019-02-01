//
//  GistsModuleDataSourceImpl.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import Foundation
import CoreData
import Model

class GistsModuleDataSourceImpl: GistsModuleDataSource {
    typealias ModuleGist = GistsModule.Gist
    typealias CoreDataGist = Model.Gist
    
    private let changeTracker: FRCChangeTracker<CoreDataGist, ModuleGist>
    
    init(frc: NSFetchedResultsController<CoreDataGist>) {
        self.changeTracker = FRCChangeTracker(fetchedResultsController: frc,
                                              cast: GistsModuleDataSourceImpl.cast)
    }
    
    //MARK: - Private
    
    private static func cast(coreDataGist: CoreDataGist) -> ModuleGist {
        let module = ModuleGist(id: coreDataGist.id,
                                ownerName: coreDataGist.owner?.name,
                                ownerAvatarURL: coreDataGist.owner?.avatarURL,
                                gistName: coreDataGist.name)
        return module
    }
    
    //MARK: - GistsDataSource
    var gistsCount: Int {
        return changeTracker.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    var gistsBatchChangeHandler: ((ChangeTracker<GistsModule.Gist>.Batch<GistsModule.Gist>) -> ())? {
        didSet {
            changeTracker.didChangeHandler = gistsBatchChangeHandler
        }
    }
    
    func performFetch() {
        try! changeTracker.fetchedResultsController.performFetch()
    }
    
    func gistFor(indexPath: IndexPath) -> GistsModule.Gist {
        return changeTracker.modelFor(indexPath: indexPath)
    }
}
