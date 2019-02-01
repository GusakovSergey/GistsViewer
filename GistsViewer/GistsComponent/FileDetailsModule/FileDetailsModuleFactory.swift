//
//  FileDetailsModuleFactory.swift
//  GistsViewer
//
//  Created by Sergey on 01/02/2019.
//

import UIKit
import CoreData

class FileDetailsModuleFactory {
    private init() {}
    
    class func fileDetailsViewController(fileId: String,
                                         context: NSManagedObjectContext) -> UIViewController {
        let interactor = FileDetailsModuleInteractorImpl(context: context,
                                                         fileId: fileId)
        let presenter = FileDetailsModulePresenterImpl(interactor: interactor)
        
        let view = UIStoryboard.gistsStoryboard().instantiateViewController(withIdentifier: "FileDetails") as! FileDetailsModuleViewController
        view.presenter = presenter
        
        return view
    }
}
