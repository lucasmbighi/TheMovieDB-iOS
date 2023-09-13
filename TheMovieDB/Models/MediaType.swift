//
//  MediaType.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 31/08/23.
//

import Foundation

enum MediaType: String, Codable, Identifiable, CaseIterable {
    case movie, serie
    
    var localizedTitle: String { "medialist.\(self == .movie ? "movies" : "series")".localized }
    
    var id: Self { self }
}
