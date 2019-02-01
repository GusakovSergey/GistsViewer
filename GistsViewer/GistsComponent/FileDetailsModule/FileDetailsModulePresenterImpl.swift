//
//  FileDetailsModulePresenterImpl.swift
//  GistsViewer
//
//  Created by Sergey on 01/02/2019.
//

import Foundation

class FileDetailsModulePresenterImpl: FileDetailsModulePresenter {
    let interactor: FileDetailsModuleInteractor
    
    init(interactor: FileDetailsModuleInteractor) {
        self.interactor = interactor
    }
    
    var fileURL: URL? {
        return interactor.fileURL
    }
    
    var fileName: String? {
        return interactor.fileName
    }
}
