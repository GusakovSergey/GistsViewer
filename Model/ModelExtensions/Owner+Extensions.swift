//
//  Owner+Extensions.swift
//  Model
//
//  Created by Sergey on 27/01/2019.
//

import Foundation
import QueryKit

extension Owner {
    static var idAttribute:Attribute<Int64> { return Attribute(#keyPath(Owner.id)) }
}

extension Owner {
    public static func predicateBy(id: Int64) -> NSPredicate {
        return idAttribute == id
    }
}
