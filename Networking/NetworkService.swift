//
//  NetworkService.swift
//  Networking
//
//  Created by Sergey on 26/01/2019.
//

import Foundation
import Alamofire

public final class NetworkService {
    public enum NetworkServiceError: Error {
        case parsingError
    }
    
    private let sessionManager = SessionManager()
    
    public init() {}
    
    public func request<T: Decodable>(_ requestConvertible: URLRequestConvertible,
                                      queue: DispatchQueue = DispatchQueue.global(),
                                      success: @escaping (T)->(),
                                      failure: @escaping (Error)->()) {
        sessionManager.request(requestConvertible).responseData(queue: queue) { (dataResponse) in
            let mappedResponse = dataResponse.flatMap({ (data) -> T in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(T.self, from: data)
            })

            if let parsedValue = mappedResponse.value {
                success(parsedValue)
            } else if let error = mappedResponse.error {
                failure(error)
            } else {
                failure(NetworkServiceError.parsingError)
            }
        }
    }
}
