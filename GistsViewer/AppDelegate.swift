//
//  AppDelegate.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import UIKit
import CoreData
import Model
import Util

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = UIStoryboard.init(name: "PreparingApp", bundle: nil).instantiateInitialViewController()
        
        NSPersistentContainer.loadGistPersistentContainer { (container) in
            Thread.onMainThread {
                self.setupApp()
            }
        }
        
        return true
    }
    
    private func setupApp() {
        window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
    }
}

