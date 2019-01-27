//
//  Owner+Mappings.swift
//  Services
//
//  Created by Sergey on 27/01/2019.
//

import Foundation
import Networking
import Model
import CoreData

extension CoreDataOwner {
    func updateWith(webOwner: WebOwner) {
        if avatarURL != webOwner.avatar_url {
            avatarURL = webOwner.avatar_url
        }
        if name != webOwner.login {
            name = webOwner.login
        }
    }
    
    @discardableResult
    static func insertToContext(context: NSManagedObjectContext, webOwner: WebOwner) -> CoreDataOwner {
        let newOwner = Owner(context: context)
        newOwner.id = webOwner.id
        newOwner.avatarURL = webOwner.avatar_url
        newOwner.name = webOwner.login
        return newOwner
    }
}
