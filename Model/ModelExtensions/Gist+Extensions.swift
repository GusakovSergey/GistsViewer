//
//  Gist+Extensions.swift
//  Model
//
//  Created by Sergey on 27/01/2019.
//

import Foundation
import QueryKit

extension Gist {
    public static var idAttribute:Attribute<String> { return Attribute(#keyPath(Gist.id)) }
    public static var updatedAtAttribute: Attribute<TimeInterval> { return Attribute(#keyPath(Gist.updatedAt))}
}

extension Attribute where AttributeType: Gist {
    var idAttribute:Attribute<String> { return attribute(AttributeType.idAttribute) }
}

extension Gist {
    public var typedFiles: Set<File> {
        if let files = files {
            return Set(files.allObjects as! [File])
        }
        return []
    }
}

extension Gist {
    public static func predicateForGistsWith(ids: [String]) -> NSPredicate {
        return Gist.idAttribute << ids
    }
    
    public static func predicateForGistWith(id: String) -> NSPredicate {
        return Gist.idAttribute == id
    }
}
