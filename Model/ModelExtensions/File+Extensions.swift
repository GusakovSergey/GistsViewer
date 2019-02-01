//
//  File+Extensions.swift
//  Model
//
//  Created by Sergey on 31/01/2019.
//

import Foundation
import QueryKit

extension File {
    public static var fileNameAttribute: Attribute<String> { return Attribute(#keyPath(File.name)) }
    static var identifierAttribute: Attribute<String> { return Attribute(#keyPath(File.identifier)) }
    static var gistAttribute: Attribute<Gist> { return Attribute(#keyPath(File.gist)) }
}

extension File {
    public static func predicateByGist(gistId: String) -> NSPredicate {
        return gistAttribute.idAttribute == gistId
    }
    
    public static func predicateBy(identifier: String) -> NSPredicate {
        return identifierAttribute == identifier
    }
}
