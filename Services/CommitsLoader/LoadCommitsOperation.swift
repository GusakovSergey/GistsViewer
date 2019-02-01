//
//  LoadCommitsOperation.swift
//  Services
//
//  Created by Sergey on 30/01/2019.
//

import Foundation
import Util
import Networking
import Model
import CoreData

class LoadCommitsOperation: AsyncOperation {
    let networkService: NetworkService
    let context: NSManagedObjectContext
    let gistId: String
    
    var resultError: Error?
    
    init(networkService: NetworkService, context: NSManagedObjectContext, gistId: String) {
        self.networkService = networkService
        self.context = context
        self.gistId = gistId
    }
    
    override func main() {
        networkService.request(GistsAPI.commits(gistId: gistId),
                               success: { [weak self] (commits: [WebCommit]) in
                                self?.handle(commits: commits)
                                self?.state = .finished
        }) { [weak self] (error) in
            self?.resultError = error
            self?.state = .finished
        }
    }
    
    private func handle(commits: [WebCommit]) {
        context.performAndWait {
            guard let gist = CoreDataGist.findOrFetch(in: context, matching: CoreDataGist.predicateForGistWith(id: gistId)) else {
                    return
            }
            
            let existedCommits = CoreDataCommit.fetch(in: context, configurationBlock: { (request) in
                request.predicate = CoreDataCommit.predicateBy(shaList: commits.map({ $0.version }))
                request.returnsObjectsAsFaults = false
            })
            
            commits.forEach({ (webCommit) in
                if !existedCommits.contains(where: {$0.sha == webCommit.version}) {
                    gist.addToCommits(CoreDataCommit.insertToContext(context: context,
                                                                     withWebCommit: webCommit))
                }
            })
            
            context.safeSave()
            
            context.refreshAllObjects()
        }
    }
}
