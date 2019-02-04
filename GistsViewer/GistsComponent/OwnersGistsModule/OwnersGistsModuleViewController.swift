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
    
    private var gistsTrackerAdapter: ChangeTrackerAdapter<GistsListTableViewCellModel, OwnersGistsModule.Gist>!
    private var tableViewDataSource: ChangeTrackerBasedDataSource<GistsListTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = presenter.obtainOwnerName()
        
        tableView.register(GistsListTableViewCell.nib(),
                           forCellReuseIdentifier: "gistCell")
        
        gistsTrackerAdapter = ChangeTrackerAdapter(adaptee: presenter.constructGistsChangeTracker(), block: { $0 })
        tableViewDataSource = ChangeTrackerBasedDataSource<GistsListTableViewCell>(changeTracker: gistsTrackerAdapter,
                                                                                   tableView: tableView,
                                                                                   cellReuseIdentifier: "gistCell")
        tableView.dataSource = tableViewDataSource
    }
}

extension OwnersGistsModuleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetailsFor(gist: gistsTrackerAdapter.adapteeTracker.modelFor(indexPath: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OwnersGistsModule.Gist: GistsListTableViewCellModel { }
