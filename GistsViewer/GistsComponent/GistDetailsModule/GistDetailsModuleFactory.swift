//
//  GistDetailsModuleFactory.swift
//  GistsViewer
//
//  Created by Sergey on 31/01/2019.
//

import Foundation
import Services

class GistDetailsModuleFactory {
    private init() { }
    
    static func gistDetailsViewController(gistId: String,
                                          servicesContainer: ServicesContainer,
                                          navigationController: UINavigationController) -> UIViewController {
        let interactor = GistDetailsModuleInteractorImpl(gistId: gistId,
                                                         commitsLoader: servicesContainer.commitsLoader,
                                                         context: servicesContainer.mainContext)
        let router = GistDetailsModuleRouterImpl(navigationController: navigationController,
                                                 servicesContainer: servicesContainer)
        let presenter = GistDetailsModulePresenterImpl(interactor: interactor,
                                                       router: router)
        
        let viewController = UIStoryboard.gistsStoryboard().instantiateViewController(withIdentifier: "GistDetails") as! GistDetailsModuleViewController
        viewController.presenter = presenter
        
        return viewController
    }
}
