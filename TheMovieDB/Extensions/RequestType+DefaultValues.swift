//
//  RequestType+BaseURL.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

//MARK: Make default values for whole app
extension RequestType {
    var urlScheme: String { "https" }
    var urlHost: String { "api.themoviedb.org" }
    var headers: [HTTPHeader] { [.acceptApplicationJson, .contentTypeApplicationJson, .authorization(.bearer)] }
    var encoder: JSONEncoder { JSONEncoder(keyEncodingStrategy: .convertToSnakeCase) }
    var decoder: JSONDecoder { JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase) }
}
