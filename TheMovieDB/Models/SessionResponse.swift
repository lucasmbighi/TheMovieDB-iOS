//
//  SessionResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

struct SessionResponse {
    let success: Bool
    let sessionId: String
}

extension SessionResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case success, sessionId = "session_id"
    }
}
