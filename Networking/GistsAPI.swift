//
//  WebAPI.swift
//  Networking
//
//  Created by Sergey on 26/01/2019.
//

import Foundation
import Alamofire

public enum GistsAPI: URLRequestConvertible {
    case gists
    case commits(gistId: String)
    
    private static let baseURLString = "https://api.github.com"
    
    private var method: HTTPMethod {
        switch self {
        case .gists:
            return .get
        case .commits:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .gists:
            return "/gists/public"
        case .commits(gistId: let gistId):
            return "/gists/\(gistId)/commits"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .gists:
            return ["per_page" : 100]
        case .commits:
            return ["per_page" : 100]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try GistsAPI.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .gists, .commits:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
