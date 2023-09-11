//
//  Encodable+asDictionary.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 31/08/23.
//

import Foundation

extension Encodable {
    func asDictionary(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) -> [String: String]? {
        let data = try? JSONEncoder(keyEncodingStrategy: keyEncodingStrategy).encode(self)
        guard let dictionary = try? JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? [String: String] else {
            return nil
        }
        return dictionary
    }
}
