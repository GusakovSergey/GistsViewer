//
//  OwnersGistsModule.swift
//  GistsViewer
//
//  Created by Sergey on 02/02/2019.
//

import Foundation

class OwnersGistsModule {
    private init() {}
    
    struct Gist {
        let id: String?
        let ownerName: String?
        let ownerAvatarURL: String?
        let gistName: String?
        
        init(id: String?, ownerName: String?, ownerAvatarURL: String?, gistName: String?) {
            self.id = id
            self.ownerName = ownerName
            self.ownerAvatarURL = ownerAvatarURL
            self.gistName = gistName
        }
    }
}

protocol OwnersGistsModuleRouter {
    func showGistDetails(gistId: String)
}

protocol OwnersGistsModuleInteractor {
    func obtainOwnerName() -> String?
    func constructGistsChangeTracker() -> ChangeTracker<OwnersGistsModule.Gist>
}

protocol OwnersGistsModuleView: class {
    
}

protocol OwnersGistsModulePresenter {
    func showDetailsFor(gist: OwnersGistsModule.Gist)
    
    func obtainOwnerName() -> String
    func constructGistsChangeTracker() -> ChangeTracker<OwnersGistsModule.Gist>
}
