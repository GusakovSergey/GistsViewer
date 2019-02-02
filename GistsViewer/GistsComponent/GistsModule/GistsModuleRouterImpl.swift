//
//  GistsModuleRouterImpl.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import Foundation
import Services

class GistsModuleRouterImpl: GistsRouter {
    private let servicesContainer: ServicesContainer
    private weak var navigationController: UINavigationController?
    
    init(servicesContainer: ServicesContainer, navigationController: UINavigationController) {
        self.servicesContainer = servicesContainer
        self.navigationController = navigationController
    }
    
    //MARK: - GistsRouter
    func showGistDetails(gistId: String) {
        guard let navVC = navigationController else {
            assertionFailure("navVC was lost")
            return
        }
        
        let gistDetailsVC = GistDetailsModuleFactory.gistDetailsViewController(gistId: gistId,
                                                                               servicesContainer: servicesContainer,
                                                                               navigationController: navVC)
        
        navVC.pushViewController(gistDetailsVC, animated: true)
    }
    
    func showOwnersGists(ownerId: Int64) {
        guard let navVC = navigationController else {
            assertionFailure("navVC was lost")
            return
        }
        
        let ownersGistsVC = OwnersGistsModuleFactory.ownersGistsViewController(ownerId: ownerId,
                                                                               servicesContainer: servicesContainer,
                                                                               navigationController: navVC)
        
        navVC.pushViewController(ownersGistsVC, animated: true)
    }
}
