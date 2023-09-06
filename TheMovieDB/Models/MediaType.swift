//
//  MediaType.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 31/08/23.
//

import Foundation

enum MediaType: String, Codable, Identifiable, CaseIterable {
    case movie, serie
    
    var title: String { self == .movie ? "Movies" : "Series" }
    
    var id: Self { self }
}
