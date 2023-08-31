//
//  MovieListSection.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation

enum MovieListSection: String, ListSectionProtocol {
    case nowPlaying = "Now Playing",
         popular = "Popular",
         topRated = "Top Rated",
         upcoming = "Upcoming"
}
