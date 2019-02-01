//
//  File.swift
//  Model
//
//  Created by Sergey on 31/01/2019.
//

import CoreData

public class File: NSManagedObject {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        identifier = UUID().uuidString
    }
}
