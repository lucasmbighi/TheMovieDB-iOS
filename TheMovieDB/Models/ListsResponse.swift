//
//  ListsResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 05/09/23.
//

import Foundation

struct ListsResponse: Decodable {
    let results: [ListResponse]
}
