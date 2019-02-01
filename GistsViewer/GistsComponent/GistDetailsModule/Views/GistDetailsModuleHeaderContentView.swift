//
//  GistDetailsModuleHeaderContentView.swift
//  GistsViewer
//
//  Created by Sergey on 01/02/2019.
//

import UIKit

class GistDetailsModuleHeaderContentView: UIView {
    private var prevBounds = CGRect.zero
    var boundsDidChangeHandler: (()->())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if prevBounds != bounds {
            prevBounds = bounds
            boundsDidChangeHandler?()
        }
    }
}
