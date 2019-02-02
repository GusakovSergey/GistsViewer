//
//  GistsModulePresenterImpl.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import Foundation

class GistsModulePresenterImpl: GistsModulePresenter {
    private let interactor: GistsInteractor
    private let router: GistsRouter
    
    init(interactor: GistsInteractor, router: GistsRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    //MARK: - GistsPresenter
    
    func showOwnersGists(owner: GistsModule.Owner) {
        router.showOwnersGists(ownerId: owner.id)
    }
    
    func showDetailsFor(gist: GistsModule.Gist) {
        guard let id = gist.id else { return }
        router.showGistDetails(gistId: id)
    }
    
    func constructGistsChangeTracker() -> ChangeTracker<GistsModule.Gist> {
        return interactor.constructGistsChangeTracker()
    }
    
    func constructOwnersChangeTracker() -> ChangeTracker<GistsModule.Owner> {
        return interactor.constructOwnersChangeTracker()
    }
    
    func loadNewGists(completion: @escaping (Error?) -> ()) {
        interactor.loadNewGists(completion: completion)
    }
    
    func loadNextGists(completion: @escaping (Error?) -> ()) {
        interactor.loadNewGists(completion: completion)
    }
}
