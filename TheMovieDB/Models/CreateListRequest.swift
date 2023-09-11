//
//  CreateListResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 01/09/23.
//

import Foundation

struct CreateListRequest: Encodable {
    let name: String
    let description: String
    let language: String
    
    init(name: String, description: String, language: String = "en") {
        self.name = name
        self.description = description
        self.language = language
    }
}
