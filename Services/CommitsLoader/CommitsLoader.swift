//
//  CommitsLoader.swift
//  Services
//
//  Created by Sergey on 30/01/2019.
//

import Foundation
import Util
import Networking
import CoreData

public class CommitsLoader {
    private let networkService: NetworkService
    private let context: NSManagedObjectContext
    
    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
    init(networkService: NetworkService, context: NSManagedObjectContext) {
        self.networkService = networkService
        self.context = context
    }
    
    public func loadCommitsForGist(gistId: String, completion: @escaping (Error?)->()) {
        let operation = LoadCommitsOperation(networkService: networkService,
                                             context: context,
                                             gistId: gistId)
        operation.completionBlock = {
            completion(operation.resultError)
        }
        operationQueue.addOperation(operation)
    }
}
