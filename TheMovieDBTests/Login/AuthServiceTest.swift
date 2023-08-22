//
//  AuthServiceTest.swift
//  TheMovieDBTests
//
//  Created by Lucas Bighi on 16/08/23.
//

import Foundation
@testable import TheMovieDB

final class AuthServiceTest: AuthServiceProtocol {
    
    var sessionId: String?
    
    var client: TheMovieDB.APIClient<TheMovieDB.LoginRequest>
    
    var username: String?
    
    var password: String?
    
    var accountDetails: TheMovieDB.AccountDetailResponse?
    
    init() {
        self.client = .init()
    }
    
    func getRequestToken() async throws -> TheMovieDB.RequestTokenResponse {
        let requestToken: RequestTokenResponse = try await client.stubRequest(.newToken)
        return requestToken
    }
    
    func validateToken(token: String, username: String, password: String) async throws -> TheMovieDB.RequestTokenResponse {
        let request = RequestTokenRequest(username: username, password: password, requestToken: token)
        let validatedToken: RequestTokenResponse = try await client.stubRequest(.validateToken(request: request))
        return validatedToken
    }
    
    func newSession(_ requestToken: String) async throws -> TheMovieDB.SessionResponse {
        let response: SessionResponse = try await client.stubRequest(.newSession(requestToken: requestToken))
        return response
    }
    
    func authenticate(username: String, password: String) async throws -> TheMovieDB.SessionResponse {
        self.username = username
        self.password = password
        
        let token = try await getRequestToken()
        let res = try await validateToken(token: token.requestToken, username: username, password: password)
        let session = try await newSession(res.requestToken)
        
        self.sessionId = session.sessionId
        
        return session
    }
    
    func getAccountDetails() async throws -> TheMovieDB.AccountDetailResponse {
        guard let accountDetails else {
            return try await client.stubRequest(.accountDetails(sessionId: sessionId ?? ""))
        }
        return accountDetails
    }
}
