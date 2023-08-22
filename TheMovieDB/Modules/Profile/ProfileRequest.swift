//
//  ProfileRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

enum ProfileRequest {
    case accountDetails(sessionId: String)
}

extension ProfileRequest: RequestType {
    var urlPath: String { "/account" }
    var method: HTTPMethod { .get }
    var parameters: Parameter? {
        switch self {
        case .accountDetails(let sessionId):
            return .dict(["session_id": sessionId])
        }
    }
}
