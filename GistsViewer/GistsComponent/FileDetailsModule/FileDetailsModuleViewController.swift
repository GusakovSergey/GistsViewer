//
//  FileDetailsModuleViewController.swift
//  GistsViewer
//
//  Created by Sergey on 01/02/2019.
//

import UIKit
import WebKit

class FileDetailsModuleViewController: UIViewController, WKUIDelegate, FileDetailsModuleView {
    
    var presenter: FileDetailsModulePresenter!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textView: UITextView!
    
    var reloadBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = presenter.fileName
        
        reloadBarButtonItem = UIBarButtonItem(title: "Reload",
                                              style: .plain,
                                              target: self,
                                              action: #selector(reloadFile))
        navigationItem.rightBarButtonItem = reloadBarButtonItem
        
        reloadFile()
    }
    
    //MARK: - Private
    
    @objc private func reloadFile() {
        activityIndicator.startAnimating()
        reloadBarButtonItem.isEnabled = false
        presenter.loadFile { [weak self] (result) in
            self?.handleFileLoading(result: result)
            self?.activityIndicator.stopAnimating()
            self?.reloadBarButtonItem.isEnabled = true
        }
    }
    
    private func handleFileLoading(result: FileDetailsModule.LoadFileResult) {
        switch result {
        case .string(let string):
            textView.text = string
        case .error(let error):
            presentError(error: error)
        }
    }
}
