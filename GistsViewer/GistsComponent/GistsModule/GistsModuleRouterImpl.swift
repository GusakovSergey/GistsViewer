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
        print("Show gist details controller")
    }
}
