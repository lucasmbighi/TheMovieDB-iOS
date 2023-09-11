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
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
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
        components.queryItems = parameters?.queryItems
        return components
    }
    
    var url: URL? { urlComponents.url }
}
