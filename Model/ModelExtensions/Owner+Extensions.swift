//
//  Owner+Extensions.swift
//  Model
//
//  Created by Sergey on 27/01/2019.
//

import Foundation
import QueryKit

extension Owner {
    static var idAttribute: Attribute<Int64> { return Attribute(#keyPath(Owner.id)) }
    public static var gistsCountAttribute: Attribute<Int32> { return Attribute(#keyPath(Owner.gistsCount)) }
}

extension Attribute where AttributeType == Owner {
    var idAttribute: Attribute<Int64> { return attribute(AttributeType.idAttribute) }
}

extension Owner {
    public static func predicateBy(id: Int64) -> NSPredicate {
        return idAttribute == id
    }
}
