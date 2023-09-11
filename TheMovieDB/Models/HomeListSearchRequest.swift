//
//  MediaListSearchRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 31/08/23.
//

import Foundation

struct MediaListSearchRequest: Encodable {
    let query: String
    let adult: Bool
    let language: String
    let primaryReleaseYear: String
    let region: String
    let year: String
    
    init(query: String, adult: Bool, language: String, primaryReleaseYear: String, region: String, year: String) {
        self.query = query
        self.adult = adult
        self.language = language
        self.primaryReleaseYear = primaryReleaseYear
        self.region = region
        self.year = year
    }
    
    init(query: String, adult: Bool, primaryReleaseYear: String?, year: String?) {
        self.init(
            query: query,
            adult: adult,
            language: Locale.current.identifier,
            primaryReleaseYear: primaryReleaseYear ?? "",
            region: Locale.current.language.region?.identifier ?? "",
            year: year ?? ""
        )
    }
}
