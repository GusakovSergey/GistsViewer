//
//  GistModuleFactory.swift
//  GistsViewer
//
//  Created by Sergey on 27/01/2019.
//

import UIKit
import Services

class GistsModuleFactory {
    private init() {}
    
    static func gistsViewController(servicesContainer: ServicesContainer,
                                    navigationController: UINavigationController) -> UIViewController {
        let interacotr = GistsModuleInteractorImpl(gistsLoader: servicesContainer.gistsLoader,
                                                   context: servicesContainer.mainContext)
        let router = GistsModuleRouterImpl(servicesContainer: servicesContainer,
                                           navigationController: navigationController)
        let presenter = GistsModulePresenterImpl(interactor: interacotr,
                                                 router: router)
        
        let viewController = UIStoryboard.gistsStoryboard().instantiateViewController(withIdentifier: "GistsList") as! GistsModuleViewController
        viewController.presenter = presenter
        
        return viewController
    }
}
