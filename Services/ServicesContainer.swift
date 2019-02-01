//
//  ServicesContainer.swift
//  Services
//
//  Created by Sergey on 26/01/2019.
//

import Foundation
import CoreData
import Networking

public class ServicesContainer {
    public let gistsLoader: GistsLoader
    public let commitsLoader: CommitsLoader
    public private(set) var mainContext: NSManagedObjectContext
    
    private let persistentContainer: NSPersistentContainer
    private let networkService: NetworkService
    
    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        
        self.mainContext = persistentContainer.viewContext
        self.mainContext.automaticallyMergesChangesFromParent = true
        
        self.networkService = NetworkService()
        
        let backgroundContext = persistentContainer.newBackgroundContext()
        self.gistsLoader = GistsLoader(networkService: networkService,
                                       context: backgroundContext)
        self.commitsLoader = CommitsLoader(networkService: networkService,
                                           context: backgroundContext)

    }
}
