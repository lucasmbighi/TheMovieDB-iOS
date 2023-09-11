//
//  SessionResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

struct SessionResponse: Decodable {
    let success: Bool
    let sessionId: String
}
