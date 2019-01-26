//
//  NSPersistentContainer+Loading.swift
//  Model
//
//  Created by Sergey on 26/01/2019.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    public static func loadGistPersistentContainer(completion: @escaping (NSPersistentContainer)->()) {
        let modelURL = Bundle.modelBundle.url(forResource: "GistsViewer", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(name: "GistViewer", managedObjectModel: managedObjectModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            completion(container)
        })
    }
}
