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
}

protocol GistsRouter {
    func showGistDetails(gistId: String)
}

protocol GistsInteractor {
    func constructChangeTracker() -> ChangeTracker<GistsModule.Gist>
    
    func loadNewGists(completion: @escaping (Error?)->())
}

protocol GistsModuleView: class {
    
}

protocol GistsModulePresenter {
    func showDetailsFor(gist: GistsModule.Gist)
    func constructChangeTracker() -> ChangeTracker<GistsModule.Gist>
    func loadNewGists(completion: @escaping (Error?)->())
}

protocol GistsModuleDataSource {
    var gistsCount: Int { get }
    var gistsBatchChangeHandler: ((ChangeTracker<GistsModule.Gist>.Batch<GistsModule.Gist>)->())? { get set }
    
    func performFetch()
    func gistFor(indexPath: IndexPath) -> GistsModule.Gist
}
