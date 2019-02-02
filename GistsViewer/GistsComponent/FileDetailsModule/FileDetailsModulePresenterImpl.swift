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
    
    //MARK: - FileDetailsModulePresenter
    var fileName: String? {
        return interactor.fileName
    }
    
    func loadFile(completion: @escaping (FileDetailsModule.LoadFileResult) -> ()) {
        interactor.loadFile(completion: completion)
    }
}
