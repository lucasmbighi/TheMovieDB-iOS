//
//  RequestType.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

protocol RequestType {
    var urlScheme: String { get }
    var urlHost: String { get }
    var urlPath: String { get }
    var headers: [HTTPHeader] { get }
    var method: HTTPMethod { get }
    var parameters: Parameter? { get }
}

//MARK: Make properties optionals
extension RequestType {
    var parameters: Parameter? { nil }
}

//MARK: Get-only properties
extension RequestType {
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = urlScheme
        components.host = urlHost
        components.path = urlPath
        if case let .dict(dictionary) = parameters {
            components.queryItems = dictionary.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
        }
        return components
    }
    
    var url: URL? { urlComponents.url }
}
