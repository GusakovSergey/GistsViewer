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
    func constructChangeTracker() -> ChangeTracker<GistsModule.Gist> {
        return interactor.constructChangeTracker()
    }
    
    func showDetailsFor(gist: GistsModule.Gist) {
        guard let id = gist.id else { return }
        router.showGistDetails(gistId: id)
    }
    
    func loadNewGists(completion: @escaping (Error?) -> ()) {
        interactor.loadNewGists(completion: completion)
    }
    
    func loadNextGists(completion: @escaping (Error?) -> ()) {
        interactor.loadNewGists(completion: completion)
    }
}
