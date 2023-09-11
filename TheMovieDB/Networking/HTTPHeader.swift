//
//  HTTPHeader.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import Foundation

struct HTTPHeader {
    let name: String
    let value: String
}

// MARK: Static properties
extension HTTPHeader {
    static let acceptApplicationJson = HTTPHeader(name: "accept", value: "application/json")
    static let contentTypeApplicationJson = HTTPHeader(name: "content-type", value: "application/json")
    static func authorization(_ value: Authorization) -> HTTPHeader { HTTPHeader(name: "authorization", value: value.rawValue) }
}
