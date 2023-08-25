//
//  ArrayExtensions.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 25/08/23.
//

import Foundation

extension Array {
    mutating func reversed() -> Self {
        self.reverse()
        return self
    }
}
