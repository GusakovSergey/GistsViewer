//
//  UIViewController+Extensions.swift
//  GistsViewer
//
//  Created by Sergey on 02/02/2019.
//

import UIKit

extension UIViewController {
    func presentError(error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
