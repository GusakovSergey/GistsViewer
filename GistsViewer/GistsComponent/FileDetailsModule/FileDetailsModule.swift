//
//  FileDetailsModule.swift
//  GistsViewer
//
//  Created by Sergey on 01/02/2019.
//

import Foundation

protocol FileDetailsModuleInteractor {
    var fileURL: URL? { get }
    var fileName: String? { get }
}

protocol FileDetailsModulePresenter {
    var fileURL: URL? { get }
    var fileName: String? { get }
}

protocol FileDetailsModuleView { }
