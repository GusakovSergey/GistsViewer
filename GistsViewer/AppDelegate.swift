//
//  AppDelegate.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import UIKit
import CoreData
import Util
import Services

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NSPersistentContainer.loadGistPersistentContainer { (container) in
            Thread.onMainThread {
                self.setupApp(container: container)
            }
        }
        
        return true
    }
    
    private func setupApp(container: NSPersistentContainer) {
        let servicesContainer = ServicesContainer(persistentContainer: container)
        
        let navigationController = UINavigationController()
        
        let gistsVC = GistsModuleFactory.gistsViewController(servicesContainer: servicesContainer,
                                                             navigationController: navigationController)
        
        navigationController.viewControllers = [gistsVC]
        
        window?.rootViewController = navigationController
    }
}

