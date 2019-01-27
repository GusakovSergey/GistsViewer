//
//  Gist.swift
//  Networking
//
//  Created by Sergey on 26/01/2019.
//

import Foundation

public struct Gist: Decodable {
    public let files: [String : File]
    public let owner: Owner
    public let id: String
    public let description: String?
    public let updated_at: Date
}
