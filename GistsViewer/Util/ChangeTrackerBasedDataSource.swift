//
//  ChangeTrackerBasedDataSource.swift
//  GistsViewer
//
//  Created by Sergey on 02/02/2019.
//

import UIKit

protocol ConfigurableByModelCell {
    associatedtype Model
    func configureWith(model: Model)
}

class ChangeTrackerBasedDataSource<Cell: UITableViewCell & ConfigurableByModelCell>: NSObject, UITableViewDataSource {
    let changeTracker: ChangeTracker<Cell.Model>
    let cellReuseIdentifier: String
    let tableView: UITableView
    
    init(changeTracker: ChangeTracker<Cell.Model>, tableView: UITableView, cellReuseIdentifier: String) {
        self.changeTracker = changeTracker
        self.cellReuseIdentifier = cellReuseIdentifier
        self.tableView = tableView
        super.init()
        
        changeTracker.didChangeHandler = { [weak self] (batch) in
            self?.tableView.processChangeTrackerBatch(batch,
                                                      updateCellBlock: { (indexPath, model) in
                                                        self?.updateCellAt(indexPath: indexPath, withModel: model)
            })
        }
    }
    
    //MARK: - Private
    private func updateCellAt(indexPath: IndexPath, withModel model: Cell.Model) {
        if let cell = tableView.cellForRow(at: indexPath) as? Cell {
            cell.configureWith(model: model)
        }
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return changeTracker.sectionsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return changeTracker.numberOfObjectsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                 for: indexPath) as! Cell
        cell.configureWith(model: changeTracker.modelFor(indexPath: indexPath))
        return cell
    }
}
