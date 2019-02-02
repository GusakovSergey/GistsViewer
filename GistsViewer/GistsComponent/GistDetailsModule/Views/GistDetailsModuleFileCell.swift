//
//  GistDetailsModuleFileCell.swift
//  GistsViewer
//
//  Created by Sergey on 30/01/2019.
//

import UIKit

class GistDetailsModuleFileCell: UITableViewCell {
    @IBOutlet weak var fileNameLabel: UILabel!
}

extension GistDetailsModuleFileCell: ConfigurableByModelCell {
    typealias Model = GistDetailsModule.File
    
    func configureWith(model: GistDetailsModule.File) {
        fileNameLabel.text = model.fileName
    }
}
