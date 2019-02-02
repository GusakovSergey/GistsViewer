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
    
    private var tableViewDataSource: ChangeTrackerBasedDataSource<GistsModuleGistTableViewCell>!
    private var ownersChangeTracker: ChangeTracker<GistsModule.Owner>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Gists Viewer"
        
        refreshControll.addTarget(self, action: #selector(refreshGists), for: .valueChanged)
        
        tableViewDataSource = ChangeTrackerBasedDataSource<GistsModuleGistTableViewCell>(changeTracker: presenter.constructGistsChangeTracker(),
                                                                                             tableView: tableView,
                                                                                             cellReuseIdentifier: "cell")
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
    
    //MARK: - Private
    
    private func batchUpdateHandler(batch: ChangeTracker<GistsModule.Gist>.Batch<GistsModule.Gist>) {
        tableView.processChangeTrackerBatch(batch,
                                            updateCellBlock: { (indexPath, gist) in
                                                if let cell = tableView.cellForRow(at: indexPath) {
                                                    configureCell(cell as! GistsModuleGistTableViewCell,
                                                                  withGist: gist)
                                                }
        })
    }
    
    private func configureCell(_ cell: GistsModuleGistTableViewCell, withGist gist: GistsModule.Gist) {
        cell.gistNameLabel.text = gist.gistName
        cell.gistOwnerLabel.text = gist.ownerName
        if let urlString = gist.ownerAvatarURL, let url = URL(string: urlString) {
            Nuke.loadImage(with: url,
                           into: cell.avatarImageView)
        }
    }
}

extension GistsModuleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetailsFor(gist: tableViewDataSource.changeTracker.modelFor(indexPath: indexPath))
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
