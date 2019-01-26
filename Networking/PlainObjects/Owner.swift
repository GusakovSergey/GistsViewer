//
//  Owner.swift
//  Networking
//
//  Created by Sergey on 26/01/2019.
//

import Foundation

public struct Owner: Decodable {
    public let id: Int64
    public let avatar_url: URL
    public let login: String
}
