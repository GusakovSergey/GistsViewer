//
//  ServicesContainer.swift
//  Services
//
//  Created by Sergey on 26/01/2019.
//

import Foundation
import CoreData

public class ServicesContainer {
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
}
