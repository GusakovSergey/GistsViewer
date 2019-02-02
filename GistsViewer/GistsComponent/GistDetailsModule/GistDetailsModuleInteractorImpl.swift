//
//  GistDetailsModuleInteractorImpl.swift
//  GistsViewer
//
//  Created by Sergey on 31/01/2019.
//

import Foundation
import CoreData
import Services
import Model
import QueryKit

class GistDetailsModuleInteractorImpl: GistDetailsModuleInteractor {
    let gistId: String
    let commitsLoader: CommitsLoader
    let context: NSManagedObjectContext
    
    init(gistId: String, commitsLoader: CommitsLoader, context: NSManagedObjectContext) {
        self.gistId = gistId
        self.commitsLoader = commitsLoader
        self.context = context
    }
    
    //MARK: - GistDetailsModuleInteractor
    func refreshCommits(completion: @escaping (Error?) -> ()) {
        commitsLoader.loadCommitsForGist(gistId: gistId,
                                         completion: completion)
    }
    
    func obtainGistDetails() -> GistDetailsModule.GistDetails {
        guard let gist = Gist.findOrFetch(in: context, matching: Gist.predicateForGistWith(id: gistId)) else {
            return GistDetailsModule.GistDetails(description: "", userName: "", userAvatarURL: nil)
        }
        return GistDetailsModule.GistDetails(description: gist.name ?? "",
                                             userName: gist.owner?.name ?? "",
                                             userAvatarURL: gist.owner?.avatarURL ?? "")
    }
    
    func constructFilesChangeTracker() -> ChangeTracker<GistDetailsModule.File> {
        let request: NSFetchRequest<File> = File.fetchRequest()
        request.predicate = File.predicateByGist(gistId: gistId)
        request.sortDescriptors = [File.fileNameAttribute.ascending()]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: "GistDetailsModule_files_\(gistId)")
        
        return FRCChangeTracker(fetchedResultsController: frc,
                                cast: { GistDetailsModule.File(fileName: $0.name,
                                                               identifier: $0.identifier) })
    }
    
    func constructCommitsChangeTracker() -> ChangeTracker<GistDetailsModule.Commit> {
        let request: NSFetchRequest<Commit> = Commit.fetchRequest()
        request.predicate = Commit.predicateBy(gistId: gistId)
        request.sortDescriptors = [Commit.dateAttribute.descending()]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: "GistDetailsModule_commits_\(gistId)")
        
        return FRCChangeTracker(fetchedResultsController: frc,
                                cast: { GistDetailsModule.Commit(sha: $0.sha,
                                                                 additions: $0.additions,
                                                                 deletions: $0.deletions) })
    }
}
