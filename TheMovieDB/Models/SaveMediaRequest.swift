//
//  SaveMediaRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 31/08/23.
//

import Foundation

struct SaveMediaRequest: Encodable {
    let mediaId: Int
    let mediaType: MediaType
    let favorite: Bool
}
