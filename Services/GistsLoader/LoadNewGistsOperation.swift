//
//  LoadNewGistsOperation.swift
//  Services
//
//  Created by Sergey on 27/01/2019.
//

import Foundation
import Util
import Networking
import Model
import CoreData

class LoadNewGistsOperation: AsyncOperation {
    private let networkService: NetworkService
    private let context: NSManagedObjectContext
    
    var resultError: Error?
    
    init(networkService: NetworkService,
         context: NSManagedObjectContext) {
        self.networkService = networkService
        self.context = context
    }
    
    override func main() {
        networkService.request(GistsAPI.gists,
                               success: { [weak self] (gists: [Networking.Gist]) in
                                guard let self = self else {return}
                                self.context.performAndWait {
                                    self.parse(gists: gists)
                                    self.context.safeSave()
                                    self.context.refreshAllObjects()
                                }
                                self.state = .finished
                                
        }) { [weak self] (error) in
            guard let self = self else {return}
            print(error)
            self.resultError = error
            self.state = .finished
        }
    }
    
    private func parse(gists: [Networking.Gist]) {
        let existedGistsRequest: NSFetchRequest<CoreDataGist> = CoreDataGist.fetchRequest()
        existedGistsRequest.predicate = Gist.predicateForGistsWith(ids: gists.map({ $0.id }))
        existedGistsRequest.returnsObjectsAsFaults = false
        existedGistsRequest.relationshipKeyPathsForPrefetching = [#keyPath(CoreDataGist.owner)]
        
        let existedGists = try! context.fetch(existedGistsRequest)
        
        gists.forEach { (webGist) in
            if let existedGist = existedGists.first(where: { $0.id == webGist.id }) {
                existedGist.updateWith(webGist: webGist)
            } else {
                CoreDataGist.insertToContext(context: context, webGist: webGist)
            }
        }
    }
}
