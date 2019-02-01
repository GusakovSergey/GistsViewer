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
    
    private lazy var gistsDataSource = presenter.gsistsDataSource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Gists Viewer"
        
        refreshControll.addTarget(self, action: #selector(refreshGists), for: .valueChanged)
        
        gistsDataSource.gistsBatchChangeHandler = self.batchUpdateHandler
        
        presenter.didTriggerViewLoadEvent()
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
        presenter.showDetailsFor(gist: gistsDataSource.gistFor(indexPath: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GistsModuleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gistsDataSource.gistsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gist = gistsDataSource.gistFor(indexPath: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! GistsViewControllerTableViewCell
        
        self.configureCell(cell,
                           withGist: gist)
        return cell
    }
}
