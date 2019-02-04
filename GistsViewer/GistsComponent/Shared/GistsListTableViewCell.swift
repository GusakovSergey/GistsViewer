//
//  GistsListTableViewCell.swift
//  GistsViewer
//
//  Created by Sergey on 04/02/2019.
//

import UIKit
import Nuke

protocol GistsListTableViewCellModel {
    var gistName: String? { get }
    var ownerName: String? { get }
    var ownerAvatarURL: String? { get }
}

class GistsListTableViewCell: UITableViewCell {
    
    static var rowHeight: CGFloat {
        return 60
    }
    
    static var nibName: String {
        return "GistsListTableViewCell"
    }
    
    static func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
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

extension GistsListTableViewCell: ConfigurableByModelCell {
    typealias Model = GistsListTableViewCellModel
    
    func configureWith(model: GistsListTableViewCellModel) {
        gistNameLabel.text = model.gistName
        gistOwnerLabel.text = model.ownerName
        
        if let avatarURL = model.ownerAvatarURL, let url = URL(string: avatarURL) {
            self.loadImageTask = Nuke.loadImage(with: url, into: avatarImageView)
        } else {
            imageView?.image = nil
        }
    }
}
