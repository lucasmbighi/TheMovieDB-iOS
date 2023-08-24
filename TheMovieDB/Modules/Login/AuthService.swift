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
    var biometryHelper: BiometryHelper { get set }
    var keychainWrapper: KeychainWrapper { get set }
    
    var username: String? { get set }
    var password: String? { get set }
    var hasBiometry: Bool { get }
    var accountDetails: AccountDetailResponse? { get set }
    
    func getRequestToken() async throws -> RequestTokenResponse
    func validateToken(token: String, username: String, password: String) async throws -> RequestTokenResponse
    func newSession(_ requestToken: String) async throws -> SessionResponse
    
    @MainActor
    @discardableResult
    func authenticate(username: String, password: String) async throws -> SessionResponse
    
    func authenticateWithBiometry() async throws
    func getAccountDetails() async throws -> AccountDetailResponse
    func logout() async throws
}

final class AuthService: ObservableObject, AuthServiceProtocol {
    
    @Published var sessionId: String?
    
    var client: APIClient<LoginRequest>
    var biometryHelper: BiometryHelper
    var keychainWrapper: KeychainWrapper
    
    static let shared = AuthService()
    
    var accountDetails: AccountDetailResponse?
    
    init(
        client: APIClient<LoginRequest> = .init(),
        biometryHelper: BiometryHelper = .init(),
        keychainWrapper: KeychainWrapper = .standard
    ) {
        self.client = client
        self.biometryHelper = biometryHelper
        self.keychainWrapper = keychainWrapper
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
        let token = try await getRequestToken()
        let res = try await validateToken(token: token.requestToken, username: username, password: password)
        let session = try await newSession(res.requestToken)
        
        self.sessionId = session.sessionId
        
        if !hasBiometry {
            let hasSuccessOnBiometry = try await biometryHelper.authenticate()
            if hasSuccessOnBiometry {
                self.username = username
                self.password = password
            }
        }
        return session
    }
    
    func authenticateWithBiometry() async throws {
        let hasSuccessOnBiometry = try await biometryHelper.authenticate()
        guard hasSuccessOnBiometry else { throw BiometryHelper.BiometryError.failed }
        try await authenticate(username: username ?? "", password: password ?? "")
    }
    
    func getAccountDetails() async throws -> AccountDetailResponse {
        guard let accountDetails else {
            return try await client.request(.accountDetails(sessionId: sessionId ?? ""))
        }
        return accountDetails
    }
    
    @MainActor
    func logout() async throws {
        sessionId = nil
    }
}

//MARK: Computed properties
extension AuthService {
    var isLoggedIn: Bool { sessionId != nil }
    
    var username: String? {
        get { keychainWrapper.string(forKey: "username") }
        set { keychainWrapper.set(newValue ?? "", forKey: "username") }
    }
    
    var password: String? {
        get { keychainWrapper.string(forKey: "password") }
        set { keychainWrapper.set(newValue ?? "", forKey: "password") }
    }
    
    var hasBiometry: Bool { username != nil && password != nil }
}
