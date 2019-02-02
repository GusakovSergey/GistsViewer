//
//  GistsModuleInteractorImpl.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import Foundation
import Model
import Services
import CoreData
import QueryKit
import Util

class GistsModuleInteractorImpl: GistsInteractor {
    private let gistsLoader: GistsLoader
    private let context: NSManagedObjectContext
    
    init(gistsLoader: GistsLoader, context: NSManagedObjectContext) {
        self.gistsLoader = gistsLoader
        self.context = context
    }
    
    //MARK: - GistsInteractor    
    func constructGistsChangeTracker() -> ChangeTracker<GistsModule.Gist> {
        let fetchRequest: NSFetchRequest<Gist> = Gist.fetchRequest()
        fetchRequest.sortDescriptors = [Gist.updatedAtAttribute.descending()]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        return FRCChangeTracker(fetchedResultsController: frc,
                                cast: { GistsModule.Gist(id: $0.id,
                                                         ownerName: $0.owner?.name,
                                                         ownerAvatarURL: $0.owner?.avatarURL,
                                                         gistName: $0.name) })
    }
    
    func constructOwnersChangeTracker() -> ChangeTracker<GistsModule.Owner> {
        let fetchRequest: NSFetchRequest<Owner> = Owner.fetchRequest()
        fetchRequest.sortDescriptors = [Owner.gistsCountAttribute.descending()]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        return FRCChangeTracker(fetchedResultsController: frc,
                                cast: { GistsModule.Owner(id: $0.id,
                                                          name: $0.name,
                                                          avatarURL: $0.avatarURL) })
    }

    func loadNewGists(completion: @escaping (Error?) -> ()) {
        gistsLoader.loadNewGists { (error) in
            Thread.onMainThread {
                completion(error)
            }
        }
    }  
}
