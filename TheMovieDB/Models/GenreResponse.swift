//
//  GenreResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

struct GenreResponse: Decodable, Identifiable {
    let id: Int
    let name: String
}
