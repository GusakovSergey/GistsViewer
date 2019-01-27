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
    lazy var gsistsDataSource: GistsModuleDataSource = interactor.constructGistsDataSource()
    
    func didTriggerViewLoadEvent() {
        gsistsDataSource.performFetch()
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
