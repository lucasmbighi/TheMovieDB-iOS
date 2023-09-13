//
//  Locale+ISO3166Identifier.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/09/23.
//

import Foundation

extension Locale {
    var iso3166Identifier: String {
        identifier.replacingOccurrences(of: "_", with: "-")
    }
}
