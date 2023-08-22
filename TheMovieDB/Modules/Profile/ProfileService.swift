//
//  AuthService.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

final class ProfileService: ServiceType {
    
    typealias Request = ProfileRequest
    
    var client: APIClient<Request>
    
    init(client: APIClient<Request> = .init()) {
        self.client = client
    }
    
    func getAccountDetails(sessionId: String) async throws -> AccountDetailResponse {
        let details: AccountDetailResponse = try await client.request(.accountDetails(sessionId: sessionId))
        return details
    }
}
