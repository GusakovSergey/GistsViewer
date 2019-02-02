//
//  OwnersGistsModuleGistTableViewCell.swift
//  GistsViewer
//
//  Created by Sergey on 02/02/2019.
//

import UIKit
import Nuke

class OwnersGistsModuleGistTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var gistNameLabel: UILabel!
    @IBOutlet weak var gistOwnerLabel: UILabel!
    
    private weak var loadImageTask: ImageTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 4
        avatarImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadImageTask?.cancel()
    }
}

extension OwnersGistsModuleGistTableViewCell: ConfigurableByModelCell {
    typealias Model = OwnersGistsModule.Gist
    
    func configureWith(model: OwnersGistsModule.Gist) {
        gistNameLabel.text = model.gistName
        gistOwnerLabel.text = model.ownerName
        
        if let avatarURL = model.ownerAvatarURL, let url = URL(string: avatarURL) {
            self.loadImageTask = Nuke.loadImage(with: url, into: avatarImageView)
        } else {
            imageView?.image = nil
        }
    }
}
