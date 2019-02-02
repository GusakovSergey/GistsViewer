//
//  OwnersGistsModuleInteractorImpl.swift
//  GistsViewer
//
//  Created by Sergey on 02/02/2019.
//

import Foundation
import CoreData
import Model

class OwnersGistsModuleInteractorImpl: OwnersGistsModuleInteractor {
    let context: NSManagedObjectContext
    let ownerId: Int64
    
    init(ownerId: Int64, context: NSManagedObjectContext) {
        self.context = context
        self.ownerId = ownerId
    }
    
    //MARK: - OwnersGistsModuleInteractor
    func obtainOwnerName() -> String? {
        return Owner.findOrFetch(in: context, matching: Owner.predicateBy(id: ownerId))?.name
    }
    
    func constructGistsChangeTracker() -> ChangeTracker<OwnersGistsModule.Gist> {
        let fetchRequest: NSFetchRequest<Gist> = Gist.fetchRequest()
        fetchRequest.predicate = Gist.predicateBy(ownerId: ownerId)
        fetchRequest.sortDescriptors = [Gist.updatedAtAttribute.descending()]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        return FRCChangeTracker(fetchedResultsController: frc,
                                cast: { OwnersGistsModule.Gist(id: $0.id,
                                                               ownerName: $0.owner?.name,
                                                               ownerAvatarURL: $0.owner?.avatarURL,
                                                               gistName: $0.name) })
    }
}
