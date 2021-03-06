//
//  GistDetailsModuleCommitCell.swift
//  GistsViewer
//
//  Created by Sergey on 30/01/2019.
//

import UIKit

class GistDetailsModuleCommitCell: UITableViewCell {
    @IBOutlet weak var shaLabel: UILabel!
    @IBOutlet weak var additionsLabel: UILabel!
    @IBOutlet weak var deletionsLabel: UILabel!
}

extension GistDetailsModuleCommitCell: ConfigurableByModelCell {
    typealias Model = GistDetailsModule.Commit
    
    func configureWith(model: GistDetailsModule.Commit) {
        shaLabel.text = model.sha
        additionsLabel.text = "+ \(model.additions)"
        deletionsLabel.text = "- \(model.deletions)"
    }
}
