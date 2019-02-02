//
//  GistsModuleOwnerCollectionCell.swift
//  GistsViewer
//
//  Created by Sergey on 02/02/2019.
//

import UIKit
import Nuke

class GistsModuleOwnerCollectionCell: UICollectionViewCell {
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerImageView: UIImageView!
    
    private weak var loadImageTask: ImageTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadImageTask?.cancel()
    }
}

extension GistsModuleOwnerCollectionCell: ConfigurableByModelCell {
    typealias Model = GistsModule.Owner
    func configureWith(model: GistsModule.Owner) {
        ownerNameLabel.text = model.name
        
        if let urlString = model.avatarURL, let url = URL(string: urlString) {
            loadImageTask = Nuke.loadImage(with: url, into: ownerImageView)
        } else {
            ownerImageView.image = nil
        }
    }
}
