//
//  ChangeTrackerAdapter.swift
//  GistsViewer
//
//  Created by Sergey on 04/02/2019.
//

import Foundation

class ChangeTrackerAdapter<Target, Adaptee>: ChangeTracker<Target> {
    let adapteeTracker: ChangeTracker<Adaptee>
    private var mapBlock: (Adaptee) -> (Target)
    
    init(adaptee: ChangeTracker<Adaptee>, block: @escaping (Adaptee) -> (Target)) {
        self.adapteeTracker = adaptee
        self.mapBlock = block
        super.init()
        
        adaptee.didChangeHandler = { [weak self] (batch) in
            guard let self = self else {return}
            self.didChangeHandler?(batch.map(block: self.mapBlock))
        }
    }
    
    override func sectionsCount() -> Int {
        return adapteeTracker.sectionsCount()
    }
    
    override func numberOfObjectsIn(section: Int) -> Int {
        return adapteeTracker.numberOfObjectsIn(section: section)
    }
    
    override func modelFor(indexPath: IndexPath) -> Target {
        return mapBlock(adapteeTracker.modelFor(indexPath: indexPath))
    }
}
