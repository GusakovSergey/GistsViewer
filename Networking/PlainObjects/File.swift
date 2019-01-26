//
//  File.swift
//  Networking
//
//  Created by Sergey on 26/01/2019.
//

import Foundation

public struct File: Decodable {
    public let filename: String
    public let raw_url: URL
}
