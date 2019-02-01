//
//  FileDetailsModuleInteractorImpl.swift
//  GistsViewer
//
//  Created by Sergey on 01/02/2019.
//

import Foundation
import CoreData
import Model

class FileDetailsModuleInteractorImpl: FileDetailsModuleInteractor {
    let context: NSManagedObjectContext
    let fileId: String
    
    init(context: NSManagedObjectContext, fileId: String) {
        self.context = context
        self.fileId = fileId
    }
    
    private lazy var file: File? = {
        return File.findOrFetch(in: context, matching: File.predicateBy(identifier: fileId))
    }()
    
    var fileURL: URL? {
        guard let contentURL = file?.contentURL else {
            return nil
        }
        return URL(string: contentURL)
    }
    
    var fileName: String? {
        return file?.name
    }
}
