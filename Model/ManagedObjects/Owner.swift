//
//  Owner.swift
//  Model
//
//  Created by Sergey on 02/02/2019.
//

import CoreData

public class Owner: NSManagedObject {
    
    public override func willSave() {
        super.willSave()
        let gistsCount = Int32(gists?.count ?? 0)
        if self.gistsCount != gistsCount {
            self.gistsCount = gistsCount
        }
    }    
}
