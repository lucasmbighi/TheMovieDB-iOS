//
//  AuthService.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation
import SwiftUI

protocol AuthServiceProtocol: ServiceType {
    
    associatedtype Request = LoginRequest
    
    var sessionId: String? { get set }
    
    var client: APIClient<Request> { get set }
    
    var username: String? { get set }
    var password: String? { get set }
    var accountDetails: AccountDetailResponse? { get set }
    
    func getRequestToken() async throws -> RequestTokenResponse
    func validateToken(token: String, username: String, password: String) async throws -> RequestTokenResponse
    func newSession(_ requestToken: String) async throws -> SessionResponse
    
    @MainActor
    @discardableResult
    func authenticate(username: String, password: String) async throws -> SessionResponse
    func getAccountDetails() async throws -> AccountDetailResponse
}

final class AuthService: ObservableObject, AuthServiceProtocol {
    
    @Published var sessionId: String?
    
    var client: APIClient<LoginRequest>
    
    static let shared = AuthService()
    
    var accountDetails: AccountDetailResponse?
    
    init() {
        self.client = .init()
    }
    
    func getRequestToken() async throws -> RequestTokenResponse {
        let requestToken: RequestTokenResponse = try await client.request(.newToken)
        return requestToken
    }
    
    func validateToken(token: String, username: String, password: String) async throws -> RequestTokenResponse {
        let request = RequestTokenRequest(username: username, password: password, requestToken: token)
        let validatedToken: RequestTokenResponse = try await client.request(.validateToken(request: request))
        return validatedToken
    }
    
    func newSession(_ requestToken: String) async throws -> SessionResponse {
        let response: SessionResponse = try await client.request(.newSession(requestToken: requestToken))
        return response
    }
    
    @MainActor
    @discardableResult
    func authenticate(username: String, password: String) async throws -> SessionResponse {
        self.username = username
        self.password = password
        
        let token = try await getRequestToken()
        let res = try await validateToken(token: token.requestToken, username: username, password: password)
        let session = try await newSession(res.requestToken)
        
        self.sessionId = session.sessionId
        
        return session
    }
    
    func getAccountDetails() async throws -> AccountDetailResponse {
        guard let accountDetails else {
            return try await client.request(.accountDetails(sessionId: sessionId ?? ""))
        }
        return accountDetails
    }
}

//MARK: Static properties
extension AuthService {
    var isLoggedIn: Bool { sessionId != nil }
    
    var username: String? {
        get { KeychainWrapper.standard.string(forKey: "username") }
        set { KeychainWrapper.standard.set(newValue ?? "", forKey: "username") }
    }
    
    var password: String? {
        get { KeychainWrapper.standard.string(forKey: "password") }
        set { KeychainWrapper.standard.set(newValue ?? "", forKey: "password") }
    }
}
