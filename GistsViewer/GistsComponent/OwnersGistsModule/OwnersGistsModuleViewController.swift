//
//  OwnersGistsModuleViewController.swift
//  GistsViewer
//
//  Created by Sergey on 02/02/2019.
//

import UIKit

class OwnersGistsModuleViewController: UIViewController, OwnersGistsModuleView {
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: OwnersGistsModulePresenter!
    
    private var tableViewDataSource: ChangeTrackerBasedDataSource<OwnersGistsModuleGistTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = presenter.obtainOwnerName()
        
        tableViewDataSource = ChangeTrackerBasedDataSource<OwnersGistsModuleGistTableViewCell>(changeTracker: presenter.constructGistsChangeTracker(),
                                                                                               tableView: tableView,
                                                                                               cellReuseIdentifier: "cell")
        tableView.dataSource = tableViewDataSource
    }
}

extension OwnersGistsModuleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetailsFor(gist: tableViewDataSource.changeTracker.modelFor(indexPath: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
