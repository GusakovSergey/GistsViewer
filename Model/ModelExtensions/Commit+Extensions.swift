//
//  Commit+Extensions.swift
//  Model
//
//  Created by Sergey on 30/01/2019.
//

import Foundation
import QueryKit

extension Commit {
    public static var dateAttribute: Attribute<Date> { return Attribute(#keyPath(Commit.date)) }
    static var shaAttribute: Attribute<String> { return Attribute(#keyPath(Commit.sha)) }
    static var gistAttribute: Attribute<Gist> { return Attribute(#keyPath(Commit.gist)) }
}

extension Commit {
    public static func predicateBy(shaList: [String]) -> NSPredicate {
        return shaAttribute << shaList
    }
    
    public static func predicateBy(gistId: String) -> NSPredicate {
        return gistAttribute.idAttribute == gistId
    }
}
