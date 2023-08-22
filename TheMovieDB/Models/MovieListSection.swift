//
//  MovieListSection.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation

enum MovieListSection: Int, CaseIterable {
    case nowPlaying = 0,
         popular = 1,
         topRated = 2,
         upcoming = 3
    
    var title: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        case .upcoming: return "Upcoming"
        }
    }
    
    var endpoint: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        case .upcoming: return "Upcoming"
        }
    }
}

extension MovieListSection: Identifiable {
    var id: Int { rawValue }
}
