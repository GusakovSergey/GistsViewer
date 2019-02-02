//
//  OwnersGistsModuleRouterImpl.swift
//  GistsViewer
//
//  Created by Sergey on 02/02/2019.
//

import UIKit
import Services

class OwnersGistsModuleRouterImpl: OwnersGistsModuleRouter {
    private weak var navigationController: UINavigationController?
    let servicesContainer: ServicesContainer
    
    init(navigationController: UINavigationController?, servicesContainer: ServicesContainer) {
        self.navigationController = navigationController
        self.servicesContainer = servicesContainer
    }
    
    func showGistDetails(gistId: String) {
        guard let navigationController = navigationController else {
            return
        }
        
        let viewController = GistDetailsModuleFactory.gistDetailsViewController(gistId: gistId,
                                                                                servicesContainer: servicesContainer,
                                                                                navigationController: navigationController)
        navigationController.pushViewController(viewController, animated: true)
    }
}
