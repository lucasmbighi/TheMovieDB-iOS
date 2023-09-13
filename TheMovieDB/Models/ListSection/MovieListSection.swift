//
//  MovieListSection.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation

enum MovieListSection: String, ListSectionProtocol {
    case nowPlaying = "medialist.now_playing_movie",
         popular = "medialist.popular_movie",
         topRated = "medialist.top_rated_movie",
         upcoming = "medialist.upcoming_movie"
}
