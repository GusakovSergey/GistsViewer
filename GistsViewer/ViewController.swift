//
//  ViewController.swift
//  GistsViewer
//
//  Created by Sergey on 26/01/2019.
//

import UIKit

import Networking

class ViewController: UIViewController {
    
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.request(GistsAPI.gists(page: 0, perPage: 1000), success: { (gists: [Gist]) in
            print(gists)
        }) { (error) in
            print(error.localizedDescription)
        }
    }


}

