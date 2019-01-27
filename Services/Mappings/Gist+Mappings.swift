//
//  Gist+Mappings.swift
//  Services
//
//  Created by Sergey on 27/01/2019.
//

import Foundation
import Model
import Networking
import CoreData

extension CoreDataGist {    
    func updateWith(webGist: WebGist) {
        owner?.updateWith(webOwner: webGist.owner)
        
        guard updatedAt != webGist.updated_at else {
            return
        }
        
        id = webGist.id
        name = webGist.description
        updatedAt = webGist.updated_at
        
        guard let context = self.managedObjectContext else {
            assertionFailure("try to update deleted Gist")
            return
        }
        typedFiles.forEach({ context.delete($0) })
        
        files = NSSet(array: webGist.files.values.map({ (webFile) -> CoreDataFile in
            return CoreDataFile.insertToContext(context: context,
                                                webFile: webFile)
        }))
    }
    
    @discardableResult
    static func insertToContext(context: NSManagedObjectContext, webGist: WebGist) -> CoreDataGist {
        let newGist = CoreDataGist(context: context)
        newGist.id = webGist.id
        newGist.name = webGist.description
        newGist.updatedAt = webGist.updated_at
        
        newGist.files = NSSet(array: webGist.files.values.map({ (webFile) -> CoreDataFile in
            return CoreDataFile.insertToContext(context: context,
                                                webFile: webFile)
        }))
        
        if let existedOwner = Owner.findOrFetch(in: context,
                                                matching: Owner.predicateBy(id: webGist.owner.id)) {
            newGist.owner = existedOwner
            existedOwner.updateWith(webOwner: webGist.owner)
        } else {
            newGist.owner = Owner.insertToContext(context: context,
                                                  webOwner: webGist.owner)
        }

        return newGist
    }
}
