//
//  Authenticator.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 01/09/23.
//

import Foundation

final class Authenticator: ObservableObject {
    
    static let shared = Authenticator()
    
    @Published var sessionId: String?
    @Published private var accountDetails: AccountDetailResponse?
    
    var client: APIClient<AuthenticatorRequest>
    var biometryHelper: BiometryHelper
    var keychainWrapper: KeychainWrapper
    
    private init() {
        self.client = .init()
        self.biometryHelper = .init()
        self.keychainWrapper = .standard
    }
    
    private func getRequestToken() async throws -> RequestTokenResponse {
        let requestToken: RequestTokenResponse = try await client.request(.newToken)
        return requestToken
    }
    
    private func validateToken(token: String, username: String, password: String) async throws -> RequestTokenResponse {
        let request = RequestTokenRequest(username: username, password: password, requestToken: token)
        let validatedToken: RequestTokenResponse = try await client.request(.validateToken(request: request))
        return validatedToken
    }
    
    private func newSession(_ requestToken: String) async throws -> SessionResponse {
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
                let accountDetails = try await getAccountDetails()
                self.username = username
                self.password = password
                self.name = accountDetails.name.isEmpty ? accountDetails.username : accountDetails.name
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
extension Authenticator {
    var isLoggedIn: Bool { sessionId != nil }
    
    var username: String? {
        get { keychainWrapper.string(forKey: "username") }
        set { keychainWrapper.set(newValue ?? "", forKey: "username") }
    }
    
    var password: String? {
        get { keychainWrapper.string(forKey: "password") }
        set { keychainWrapper.set(newValue ?? "", forKey: "password") }
    }
    
    var name: String? {
        get { keychainWrapper.string(forKey: "name") }
        set { keychainWrapper.set(newValue ?? "", forKey: "name") }
    }
    
    var hasBiometry: Bool { username != nil && password != nil }
}
