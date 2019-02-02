//
//  GistsModule.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import UIKit

struct GistsModule {
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
    
    struct Owner {
        let id: Int64
        let name: String?
        let avatarURL: String?
        
        init(id: Int64, name: String?, avatarURL: String?) {
            self.id = id
            self.name = name
            self.avatarURL = avatarURL
        }
    }
}

protocol GistsRouter {
    func showGistDetails(gistId: String)
    func showOwnersGists(ownerId: Int64)
}

protocol GistsInteractor {
    func constructGistsChangeTracker() -> ChangeTracker<GistsModule.Gist>
    func constructOwnersChangeTracker() -> ChangeTracker<GistsModule.Owner>
    
    func loadNewGists(completion: @escaping (Error?)->())
}

protocol GistsModuleView: class {
    
}

protocol GistsModulePresenter {
    func showDetailsFor(gist: GistsModule.Gist)
    func showOwnersGists(owner: GistsModule.Owner)
    
    func constructGistsChangeTracker() -> ChangeTracker<GistsModule.Gist>
    func constructOwnersChangeTracker() -> ChangeTracker<GistsModule.Owner>
    func loadNewGists(completion: @escaping (Error?)->())
}
