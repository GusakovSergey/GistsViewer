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
    }
}

protocol GistsRouter {
    func showGistDetails(gistId: String)
}

protocol GistsInteractor {
    func constructGistsDataSource() -> GistsModuleDataSource
    
    func loadNewGists(completion: @escaping (Error?)->())
}

protocol GistsModuleView: class {
    
}

protocol GistsModulePresenter {
    var gsistsDataSource: GistsModuleDataSource { get }
    
    func didTriggerViewLoadEvent()
    
    func showDetailsFor(gist: GistsModule.Gist)
    
    func loadNewGists(completion: @escaping (Error?)->())
}

protocol GistsModuleDataSource {
    var gistsCount: Int { get }
    var gistsBatchChangeHandler: ((ChangeTracker<GistsModule.Gist>.Batch<GistsModule.Gist>)->())? { get set }
    
    func performFetch()
    func gistFor(indexPath: IndexPath) -> GistsModule.Gist
}
