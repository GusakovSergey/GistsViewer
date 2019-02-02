//
//  GistDetailsModuleViewController.swift
//  GistsViewer
//
//  Created by Sergey on 30/01/2019.
//

import UIKit
import Nuke

class GistDetailsModuleViewController: UIViewController, GistDetailsModuleView {
    
    private enum ContentType {
        case files(dataSource: ChangeTrackerBasedDataSource<GistDetailsModuleFileCell>)
        case commits(dataSource: ChangeTrackerBasedDataSource<GistDetailsModuleCommitCell>)
    }
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var gistDescriptionLabel: UILabel!
    @IBOutlet weak var headerContentView: GistDetailsModuleHeaderContentView!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: GistDetailsModulePresenter!
    
    private var currentContentType: ContentType!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Gist Description"
        
        headerContentView.boundsDidChangeHandler = { [weak self] in
            guard let self = self else {return}
            self.tableView.tableHeaderView?.frame = self.headerContentView.bounds
            self.tableView.tableHeaderView = self.tableView.tableHeaderView
        }
        
        let gistDetails = presenter.gistDetails
        
        userNameLabel.text = gistDetails.userName
        gistDescriptionLabel.text = gistDetails.description
        if let avatarURL = gistDetails.userAvatarURL, let url = URL(string: avatarURL) {
            Nuke.loadImage(with: url, into: userAvatarImageView)
        }
        
        switchToFilesChangeTracker()
    }
    
    //MARK: - Actions
    @IBAction func sigmentedControllCanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            switchToFilesChangeTracker()
        case 1:
            presenter.refreshCommits(completion: {(_) in })
            switchToCommitsChangeTracker()
        default:
            assertionFailure("unknown segment index")
        }
        tableView.reloadData()
    }
    
    //MARK: - Private
    
    private func switchToFilesChangeTracker() {
        let dataSource = ChangeTrackerBasedDataSource<GistDetailsModuleFileCell>(changeTracker: presenter.constructFilesChangeTracker(),
                                                                                 tableView: tableView,
                                                                                 cellReuseIdentifier: "fileCell")
        currentContentType = .files(dataSource: dataSource)
        tableView.dataSource = dataSource
    }
    
    private func switchToCommitsChangeTracker() {
        let dataSource = ChangeTrackerBasedDataSource<GistDetailsModuleCommitCell>(changeTracker: presenter.constructCommitsChangeTracker(),
                                                                                   tableView: tableView,
                                                                                   cellReuseIdentifier: "commitCell")
        currentContentType = .commits(dataSource: dataSource)
        tableView.dataSource = dataSource
    }
}

extension GistDetailsModuleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentContentType! {
        case .files(dataSource: let dataSource):
            let file = dataSource.changeTracker.modelFor(indexPath: indexPath)
            presenter.showDetailsFor(file: file)
        case .commits:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
