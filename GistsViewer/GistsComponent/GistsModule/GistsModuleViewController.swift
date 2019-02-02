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
    
    let refreshControll = UIRefreshControl()
    
    var presenter: GistsModulePresenter!
    
    private var tableViewDataSource: ChangeTrackerBasedDataSource<GistsViewControllerTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Gists Viewer"
        
        refreshControll.addTarget(self, action: #selector(refreshGists), for: .valueChanged)
        
        tableViewDataSource = ChangeTrackerBasedDataSource<GistsViewControllerTableViewCell>(changeTracker: presenter.constructChangeTracker(),
                                                                                             tableView: tableView,
                                                                                             cellReuseIdentifier: "cell")
        tableView.dataSource = tableViewDataSource
        
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
                                                    configureCell(cell as! GistsViewControllerTableViewCell,
                                                                  withGist: gist)
                                                }
        })
    }
    
    private func configureCell(_ cell: GistsViewControllerTableViewCell, withGist gist: GistsModule.Gist) {
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
