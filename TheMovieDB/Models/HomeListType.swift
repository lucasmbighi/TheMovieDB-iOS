//
//  HomeListType.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 31/08/23.
//

import Foundation

enum HomeListType: String, Identifiable, CaseIterable {
    case movie = "Movies", serie = "Series"
    
    var id: Self { self }
}
