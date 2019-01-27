//
//  Managed.swift
//  Model
//
//  Created by Sergey on 27/01/2019.
//

import Foundation
import CoreData

public protocol Managed: class, NSFetchRequestResult {
}

extension Managed where Self: NSManagedObject {
    
    public static var entityName: String { return entity().name!  }
    
    public static func fetch(in context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<Self>) -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        return try! context.fetch(request)
    }
    
    public static func findOrCreate(in context: NSManagedObjectContext, matching predicate: NSPredicate, configure: (Self) -> ()) -> Self {
        guard let object = findOrFetch(in: context, matching: predicate) else {
            let newObject = Self(context: context)
            configure(newObject)
            return newObject
        }
        return object
    }
    
    public static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        guard let object = materializedObject(in: context, matching: predicate) else {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
                }.first
        }
        return object
    }
    
    public static func materializedObject(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.isFault && !object.isDeleted {
            guard let result = object as? Self, predicate.evaluate(with: result) else { continue }
            return result
        }
        return nil
    }
    
    public static func removeAllAt(context: NSManagedObjectContext) {
        let allObjects = Self.fetch(in: context)
        allObjects.forEach({ context.delete($0) })
    }
}
