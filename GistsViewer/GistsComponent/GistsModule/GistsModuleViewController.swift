//
//  GistsModuleViewController.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import UIKit
import Util
import Nuke

class GistsModuleViewController: UIViewController, GistsModuleView {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let refreshControll = UIRefreshControl()
    
    var presenter: GistsModulePresenter!
    
    private var gistsTrackerAdapter: ChangeTrackerAdapter<GistsListTableViewCellModel, GistsModule.Gist>!
    private var tableViewDataSource: ChangeTrackerBasedDataSource<GistsListTableViewCell>!
    private var ownersChangeTracker: ChangeTracker<GistsModule.Owner>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Gists Viewer"
        
        tableView.register(GistsListTableViewCell.nib(),
                           forCellReuseIdentifier: "gistCell")
        
        refreshControll.addTarget(self, action: #selector(refreshGists), for: .valueChanged)
        
        gistsTrackerAdapter = ChangeTrackerAdapter<GistsListTableViewCellModel, GistsModule.Gist>(adaptee: presenter.constructGistsChangeTracker(),
                                                                                                  block: { $0 })
        
        tableViewDataSource = ChangeTrackerBasedDataSource<GistsListTableViewCell>(changeTracker: gistsTrackerAdapter,
                                                                                   tableView: tableView,
                                                                                   cellReuseIdentifier: "gistCell")
        tableView.dataSource = tableViewDataSource
        
        ownersChangeTracker = presenter.constructOwnersChangeTracker()
        ownersChangeTracker.didChangeHandler = { [weak self] (_) in
            self?.collectionView.reloadData()
        }
        
        presenter.loadNewGists(completion: { [weak self] (_) in
            guard let self = self else {return}
            self.tableView.refreshControl = self.refreshControll
        })
    }
    
    //MARK: - Actions
    
    @objc func refreshGists() {
        presenter.loadNewGists { [weak self] (_) in
            self?.refreshControll.endRefreshing()
        }
    }
}

extension GistsModuleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetailsFor(gist: gistsTrackerAdapter.adapteeTracker.modelFor(indexPath: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GistsModuleViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let changeTrackerObjectsCount = ownersChangeTracker.numberOfObjectsIn(section: section)
        return changeTrackerObjectsCount <= 10 ? changeTrackerObjectsCount : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ownerCell",
                                                      for: indexPath) as! GistsModuleOwnerCollectionCell
        cell.configureWith(model: ownersChangeTracker.modelFor(indexPath: indexPath))
        return cell
    }
}

extension GistsModuleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showOwnersGists(owner: ownersChangeTracker.modelFor(indexPath: indexPath))
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension GistsModule.Gist: GistsListTableViewCellModel { }
