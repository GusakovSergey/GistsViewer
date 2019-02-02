//
//  FileDetailsModuleInteractorImpl.swift
//  GistsViewer
//
//  Created by Sergey on 01/02/2019.
//

import Foundation
import CoreData
import Model
import Nuke

class FileDetailsModuleInteractorImpl: FileDetailsModuleInteractor {
    enum LoadingError: Error {
        case urlNotFound
    }
    
    private let context: NSManagedObjectContext
    private let fileId: String
    
    private lazy var file: File? = {
        return File.findOrFetch(in: context, matching: File.predicateBy(identifier: fileId))
    }()
    
    private lazy var fileURL: URL? = {
        guard let contentURL = file?.contentURL else {
            return nil
        }
        return URL(string: contentURL)
    }()
    
    init(context: NSManagedObjectContext, fileId: String) {
        self.context = context
        self.fileId = fileId
    }
    
    //MARK: - FileDetailsModuleInteractor
    var fileName: String? {
        return file?.name
    }
    
    func loadFile(completion: @escaping (FileDetailsModule.LoadFileResult) -> ()) {
        guard let url = fileURL else {
            completion(.error(LoadingError.urlNotFound))
            return
        }
        
        DispatchQueue.global().async {
            do {
                let string = try String(contentsOf: url)
                Thread.onMainThread {
                    completion(.string(string))
                }
            } catch {
                Thread.onMainThread {
                    completion(.error(error))
                }
            }
        }
    }
}
