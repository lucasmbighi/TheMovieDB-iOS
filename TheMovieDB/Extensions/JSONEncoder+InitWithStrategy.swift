//
//  JSONEncoder+InitWithStrategy.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 30/08/23.
//

import Foundation

extension JSONEncoder {
    convenience init(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy) {
        self.init()
        self.keyEncodingStrategy = keyEncodingStrategy
    }
}
