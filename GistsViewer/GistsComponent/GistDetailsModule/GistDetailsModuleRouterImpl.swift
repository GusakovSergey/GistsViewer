//
//  GistDetailsModuleRouterImpl.swift
//  GistsViewer
//
//  Created by Sergey on 31/01/2019.
//

import UIKit
import Services

class GistDetailsModuleRouterImpl: GistDetailsModuleRouter {
    private weak var navigationController: UINavigationController?
    private let servicesContainer: ServicesContainer
    
    init(navigationController: UINavigationController, servicesContainer: ServicesContainer) {
        self.navigationController = navigationController
        self.servicesContainer = servicesContainer
    }
    
    func showFileDetails(fileId: String) {
        print("TODO: show file screen")
    }
}
