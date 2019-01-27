//
//  GistsLoader.swift
//  Services
//
//  Created by Sergey on 26/01/2019.
//

import Foundation
import CoreData
import Networking

public class GistsLoader {
    private let context: NSManagedObjectContext
    private let networkService: NetworkService
    
    private let syncQueue = DispatchQueue(label: "")
    private let operationQueue: OperationQueue = {
       let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        return operationQueue
    }()
    
    init(networkService: NetworkService,
         context: NSManagedObjectContext) {
        self.context = context
        self.networkService = networkService
    }
    
    //MARK: - Public
    public func loadNewGists(completion: @escaping (Error?) -> ()) {
        let loadNextGistsOpeation = LoadNewGistsOperation(networkService: networkService,
                                                          context: context)
        
        loadNextGistsOpeation.completionBlock = {
            completion(loadNextGistsOpeation.resultError)
        }
        operationQueue.addOperation(loadNextGistsOpeation)
    }
}
