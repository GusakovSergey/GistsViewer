//
//  GistDetailsModule.swift
//  GistsViewer
//
//  Created by Sergey on 30/01/2019.
//

import Foundation
import CoreData
import Model

class GistDetailsModule {
    private init() {}
    
    struct Commit {
        let sha: String?
        let additions: Int64
        let deletions: Int64
        
        init(sha: String?, additions: Int64, deletions: Int64) {
            self.sha = sha
            self.additions = additions
            self.deletions = deletions
        }
    }
    
    struct File {
        let fileName: String?
        let identifier: String?
        
        init(fileName: String?, identifier: String?) {
            self.fileName = fileName
            self.identifier = identifier
        }
    }
    
    struct GistDetails {
        let description: String
        let userName: String
        let userAvatarURL: String?
        
        init(description: String, userName: String, userAvatarURL: String?) {
            self.description = description
            self.userName = userName
            self.userAvatarURL = userAvatarURL
        }
    }
}

protocol GistDetailsModuleView {
    
}

protocol GistDetailsModulePresenter {
    var gistDetails: GistDetailsModule.GistDetails { get }
    
    func constructFilesChangeTracker() -> ChangeTracker<GistDetailsModule.File>
    func constructCommitsChangeTracker() -> ChangeTracker<GistDetailsModule.Commit>
    func showDetailsFor(file: GistDetailsModule.File)
    func refreshCommits(completion: @escaping (Error?)->())
}

protocol GistDetailsModuleInteractor {
    func refreshCommits(completion: @escaping (Error?)->())
    func obtainGistDetails() -> GistDetailsModule.GistDetails
    func constructFilesChangeTracker() -> ChangeTracker<GistDetailsModule.File>
    func constructCommitsChangeTracker() -> ChangeTracker<GistDetailsModule.Commit>
}

protocol GistDetailsModuleRouter {
    func showFileDetails(fileId: String)
}
