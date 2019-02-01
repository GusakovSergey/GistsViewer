//
//  Commit.swift
//  Networking
//
//  Created by Sergey on 30/01/2019.
//

import Foundation

public struct Commit: Codable {
    public struct ChangeStatus: Codable {
        public let deletions, additions, total: Int64
    }
    
    public let version: String
    public let changeStatus: ChangeStatus
    public let committedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case version
        case changeStatus = "change_status"
        case committedAt = "committed_at"
    }
}
