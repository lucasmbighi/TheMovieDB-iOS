//
//  SerieListSection.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 31/08/23.
//

import Foundation

enum SerieListSection: String, ListSectionProtocol {
    case airingToday = "Airing Today",
         onTheAir = "On The Air",
         popular = "Popular",
         topRated = "Top Rated"
}
