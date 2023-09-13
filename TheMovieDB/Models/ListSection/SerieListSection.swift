//
//  SerieListSection.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 31/08/23.
//

import Foundation

enum SerieListSection: String, ListSectionProtocol {
    case airingToday = "medialist.airing_today_serie",
         onTheAir = "medialist.on_the_air_serie",
         popular = "medialist.popular_serie",
         topRated = "medialist.top_rated_serie"
}
