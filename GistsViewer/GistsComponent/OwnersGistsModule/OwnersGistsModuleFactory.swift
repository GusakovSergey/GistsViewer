//
//  OwnersGistsModuleFactory.swift
//  GistsViewer
//
//  Created by Sergey on 02/02/2019.
//

import UIKit
import Services

class OwnersGistsModuleFactory {
    class func ownersGistsViewController(ownerId: Int64,
                                         servicesContainer: ServicesContainer,
                                         navigationController: UINavigationController) -> UIViewController {
        let interacor = OwnersGistsModuleInteractorImpl(ownerId: ownerId,
                                                        context: servicesContainer.mainContext)
        let router = OwnersGistsModuleRouterImpl(navigationController: navigationController,
                                                 servicesContainer: servicesContainer)
        let presenter = OwnersGistsModulePresenterImpl(interactor: interacor,
                                                       router: router)
        
        let view = UIStoryboard.gistsStoryboard().instantiateViewController(withIdentifier: "OwnersGists") as! OwnersGistsModuleViewController
        view.presenter = presenter
        
        return view
    }
}
