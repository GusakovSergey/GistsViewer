//
//  FileDetailsModule.swift
//  GistsViewer
//
//  Created by Sergey on 01/02/2019.
//

import Foundation

class FileDetailsModule {
    private init() {}
    
    enum LoadFileResult {
        case string(String)
        case error(Error)
    }
}

protocol FileDetailsModuleInteractor {
    var fileName: String? { get }
    
    func loadFile(completion: @escaping (FileDetailsModule.LoadFileResult)->())
}

protocol FileDetailsModulePresenter {
    var fileName: String? { get }
    
    func loadFile(completion: @escaping (FileDetailsModule.LoadFileResult)->())
}

protocol FileDetailsModuleView { }
