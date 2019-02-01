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
    
    var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var reloadBarButtonItem: UIBarButtonItem!
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.isLoading))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        
        title = presenter.fileName
        
        reloadBarButtonItem = UIBarButtonItem(title: "Reload",
                                              style: .plain,
                                              target: self,
                                              action: #selector(reloadWebView))
        navigationItem.rightBarButtonItem = reloadBarButtonItem
        
        guard let url = presenter.fileURL else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.isLoading),
                            options: [.initial, .new],
                            context: nil)        
    }
    
    //MARK: - Private
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: view.frame, configuration: webConfiguration)
        webView.uiDelegate = self
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(webView, at: 0)
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: webView.rightAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc private func reloadWebView() {
        webView.reload()
    }
    
    //MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.isLoading) {
            if webView.isLoading {
                activityIndicator.startAnimating()
                reloadBarButtonItem.isEnabled = false
            } else {
                activityIndicator.stopAnimating()
                reloadBarButtonItem.isEnabled = true
            }
        }
    }
}
