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
    func constructGistsDataSource() -> GistsModuleDataSource {
        let fetchRequest: NSFetchRequest<Gist> = Gist.fetchRequest()
        fetchRequest.sortDescriptors = [Gist.updatedAtAttribute.descending()]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        return GistsModuleDataSourceImpl(frc: frc)
    }

    func loadNewGists(completion: @escaping (Error?) -> ()) {
        gistsLoader.loadNewGists { (error) in
            Thread.onMainThread {
                completion(error)
            }
        }
    }  
}
