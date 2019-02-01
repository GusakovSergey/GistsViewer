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
        case files(tracker: ChangeTracker<GistDetailsModule.File>)
        case commits(tracker: ChangeTracker<GistDetailsModule.Commit>)
    }
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var gistDescriptionLabel: UILabel!
    @IBOutlet weak var headerContentView: GistDetailsModuleHeaderContentView!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: GistDetailsModulePresenter!
    
    private var currentContentType: ContentType! {
        didSet {
            if let oldValue = oldValue {
                switch oldValue {
                case .commits(tracker: let tracker):
                    tracker.didChangeHandler = nil
                case .files(tracker: let tracker):
                    tracker.didChangeHandler = nil
                }
            }
        }
    }
    
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
        let tracker = presenter.constructFilesChangeTracker()
        tracker.didChangeHandler = { [weak self] (batch) in
            self?.tableView.processChangeTrackerBatch(batch,
                                                      updateCellBlock: { (indexPath, file) in
                                                        if let cell = self?.tableView.cellForRow(at: indexPath) as? GistDetailsModuleFileCell {
                                                            self?.updateFileCell(cell: cell,
                                                                                 withFile: file)
                                                        }
                                                        
            })
        }
        currentContentType = .files(tracker: tracker)
    }
    
    private func updateFileCell(cell: GistDetailsModuleFileCell, withFile file: GistDetailsModule.File) {
        cell.fileNameLabel.text = file.fileName
    }
    
    private func switchToCommitsChangeTracker() {
        let tracker = presenter.constructCommitsChangeTracker()
        tracker.didChangeHandler = { [weak self] (batch) in
            self?.tableView.processChangeTrackerBatch(batch,
                                                      updateCellBlock: { (indexPath, commit) in
                                                        if let cell = self?.tableView.cellForRow(at: indexPath) as? GistDetailsModuleCommitCell {
                                                            self?.updateCommitCell(cell: cell,
                                                                                   withCommit: commit)
                                                        }
                                                        
            })
        }
        currentContentType = .commits(tracker: tracker)
    }
    
    private func updateCommitCell(cell: GistDetailsModuleCommitCell, withCommit commit: GistDetailsModule.Commit) {
        cell.shaLabel.text = commit.sha
        cell.additionsLabel.text = "+ \(commit.additions)"
        cell.deletionsLabel.text = "- \(commit.deletions)"
    }
}

extension GistDetailsModuleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentContentType! {
        case .commits(tracker: let tracker):
            return tracker.numberOfObjectsIn(section: section)
        case .files(tracker: let tracker):
            return tracker.numberOfObjectsIn(section: section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch currentContentType! {
        case .commits(tracker: let tracker):
            cell = tableView.dequeueReusableCell(withIdentifier: "commitCell", for: indexPath)
            updateCommitCell(cell: cell as! GistDetailsModuleCommitCell,
                             withCommit: tracker.modelFor(indexPath: indexPath))
        case .files(tracker: let tracker):
            cell = tableView.dequeueReusableCell(withIdentifier: "fileCell",
                                                 for: indexPath)
            updateFileCell(cell: cell as! GistDetailsModuleFileCell,
                           withFile: tracker.modelFor(indexPath: indexPath))
        }
        return cell
    }
}

extension GistDetailsModuleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentContentType! {
        case .files(tracker: let tracker):
            let file = tracker.modelFor(indexPath: indexPath)
            presenter.showDetailsFor(file: file)
        case .commits(tracker: _):
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
