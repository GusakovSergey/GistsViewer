//
//  File+Mappings.swift
//  Services
//
//  Created by Sergey on 27/01/2019.
//

import Foundation
import Model
import Networking
import CoreData


extension CoreDataFile {
    @discardableResult
    static func insertToContext(context: NSManagedObjectContext, webFile: WebFile) -> CoreDataFile {
        let newFile = CoreDataFile(context: context)
        newFile.name = webFile.filename
        newFile.contentURL = webFile.raw_url
        return newFile
    }
}
