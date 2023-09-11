//
//  AuthenticatorRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

enum AuthenticatorRequest {
    case newToken
    case validateToken(request: RequestTokenRequest)
    case newSession(requestToken: String)
    case accountDetails(sessionId: String)
}

extension AuthenticatorRequest: RequestType {
    var urlPath: String {
        switch self {
        case .newToken:
            return "/3/authentication/token/new"
        case .validateToken:
            return "/3/authentication/token/validate_with_login"
        case .newSession:
            return "/3/authentication/session/new"
        case .accountDetails:
            return "/3/account"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .newToken, .accountDetails:
            return .get
        case .validateToken, .newSession:
            return .post
        }
    }

    var parameters: Parameter? {
        switch self {
        case .newToken:
            return nil
        case .validateToken(let request):
            return .encodable(request)
        case .newSession(let requestToken):
            return .dict(["request_token": requestToken])
        case .accountDetails(let sessionId):
            return .dict(["session_id": sessionId])
        }
    }
}
