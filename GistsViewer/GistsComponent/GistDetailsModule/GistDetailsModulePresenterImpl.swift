//
//  GistDetailsModulePresenterImpl.swift
//  GistsViewer
//
//  Created by Sergey on 31/01/2019.
//

import Foundation

class GistDetailsModulePresenterImpl: GistDetailsModulePresenter {
    let interactor: GistDetailsModuleInteractor
    let router: GistDetailsModuleRouter
    
    init(interactor: GistDetailsModuleInteractor, router: GistDetailsModuleRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    private(set) lazy var gistDetails: GistDetailsModule.GistDetails = {
        return interactor.obtainGistDetails()
    }()
    
    func constructFilesChangeTracker() -> ChangeTracker<GistDetailsModule.File> {
        return interactor.constructFilesChangeTracker()
    }
    
    func constructCommitsChangeTracker() -> ChangeTracker<GistDetailsModule.Commit> {
        return interactor.constructCommitsChangeTracker()
    }
    
    func showDetailsFor(file: GistDetailsModule.File) {
        guard let fileId = file.identifier else {
            return
        }
        router.showFileDetails(fileId: fileId)
    }
    
    func refreshCommits(completion: @escaping (Error?) -> ()) {
        interactor.refreshCommits(completion: completion)
    }
}
