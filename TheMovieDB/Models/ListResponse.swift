//
//  ListResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 05/09/23.
//

import Foundation

struct ListResponse: Decodable, Identifiable, Hashable {
    let description: String
    let id: Int
    let listType: MediaType
    let name: String
    let posterPath: String?
}
