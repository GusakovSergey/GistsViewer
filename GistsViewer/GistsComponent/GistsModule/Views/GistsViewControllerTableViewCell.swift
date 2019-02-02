//
//  GistsViewControllerTableViewCell.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import UIKit
import Nuke

class GistsViewControllerTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var gistNameLabel: UILabel!
    @IBOutlet weak var gistOwnerLabel: UILabel!
    
    private var loadImageTask: ImageTask?
    
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

extension GistsViewControllerTableViewCell: ConfigurableByModelCell {
    typealias Model = GistsModule.Gist
    
    func configureWith(model: GistsModule.Gist) {
        gistNameLabel.text = model.gistName
        gistOwnerLabel.text = model.ownerName
        
        if let avatarURL = model.ownerAvatarURL, let url = URL(string: avatarURL) {
            self.loadImageTask = Nuke.loadImage(with: url, into: avatarImageView)
        } else {
            imageView?.image = nil
        }
    }
}
