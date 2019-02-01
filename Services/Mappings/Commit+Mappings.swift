//
//  Commit+Mappings.swift
//  Services
//
//  Created by Sergey on 30/01/2019.
//

import Foundation
import Model
import Networking
import CoreData

extension CoreDataCommit {
    @discardableResult
    static func insertToContext(context: NSManagedObjectContext, withWebCommit webCommit: WebCommit) -> CoreDataCommit {
        let commit = CoreDataCommit(context: context)
        commit.additions = webCommit.changeStatus.additions
        commit.deletions = webCommit.changeStatus.deletions
        commit.date = webCommit.committedAt
        commit.sha = webCommit.version
        return commit
    }
}
