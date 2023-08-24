//
//  AuthServiceTest.swift
//  TheMovieDBTests
//
//  Created by Lucas Bighi on 16/08/23.
//

import Foundation
@testable import TheMovieDB

final class AuthServiceTest: AuthServiceProtocol {
    
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
        let requestToken: RequestTokenResponse = try await client.stubRequest(.newToken)
        return requestToken
    }
    
    func validateToken(token: String, username: String, password: String) async throws -> RequestTokenResponse {
        let request = RequestTokenRequest(username: username, password: password, requestToken: token)
        let validatedToken: RequestTokenResponse = try await client.stubRequest(.validateToken(request: request))
        return validatedToken
    }
    
    func newSession(_ requestToken: String) async throws -> SessionResponse {
        let response: SessionResponse = try await client.stubRequest(.newSession(requestToken: requestToken))
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
}

//MARK: Computed properties
extension AuthServiceTest {
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
