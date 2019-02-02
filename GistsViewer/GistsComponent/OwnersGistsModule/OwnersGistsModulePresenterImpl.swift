//
//  OwnersGistsModulePresenterImpl.swift
//  GistsViewer
//
//  Created by Sergey on 02/02/2019.
//

import Foundation

class OwnersGistsModulePresenterImpl: OwnersGistsModulePresenter {
    let interactor: OwnersGistsModuleInteractor
    let router: OwnersGistsModuleRouter
    
    init(interactor: OwnersGistsModuleInteractor, router: OwnersGistsModuleRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    //MARK: - OwnersGistsModulePresenter
    func showDetailsFor(gist: OwnersGistsModule.Gist) {
        guard let gistId = gist.id else {
            return
        }
        router.showGistDetails(gistId: gistId)
    }
    
    func obtainOwnerName() -> String {
        return interactor.obtainOwnerName() ?? ""
    }
    
    func constructGistsChangeTracker() -> ChangeTracker<OwnersGistsModule.Gist> {
        return interactor.constructGistsChangeTracker()
    }
}
