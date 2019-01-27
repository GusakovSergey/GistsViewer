//
//  GistsViewControllerTableViewCell.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import UIKit

class GistsViewControllerTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var gistNameLabel: UILabel!
    @IBOutlet weak var gistOwnerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 4
        avatarImageView.clipsToBounds = true
    }
}
