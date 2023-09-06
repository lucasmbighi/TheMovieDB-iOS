//
//  Parameter.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

enum Parameter {
    case dict([String: Any]),
         encodable(_ encodable: Encodable),
         both(queryItems: [String: Any], body: Encodable)
}

// MARK: Computed properties
extension Parameter {
    var queryItems: [URLQueryItem]? {
        switch self {
        case .dict(let dictionary), .both(let dictionary, _):
            return dictionary.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
        default:
            return nil
        }
    }
}
