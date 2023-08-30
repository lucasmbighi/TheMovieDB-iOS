//
//  JSONDecoder+InitWithStrategy.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 30/08/23.
//

import Foundation

extension JSONDecoder {
    convenience init(keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = keyDecodingStrategy
    }
}
