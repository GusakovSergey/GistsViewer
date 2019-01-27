//
//  NSManagedObjectContext+Extensions.swift
//  Model
//
//  Created by Sergey on 26/01/2019.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    public func safeSave() {
        do {
            try save()
        } catch {
            print(error)
        }
    }
}
