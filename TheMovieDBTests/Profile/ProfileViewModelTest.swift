//
//  ProfileViewModelTest.swift
//  TheMovieDBTests
//
//  Created by Lucas Bighi on 23/08/23.
//

@testable import TheMovieDB

final class ProfileViewModelTest: ProfileViewModelProtocol {
    var service: ProfileService
    var authService: any AuthServiceProtocol
    
    var accountDetails: AccountDetailResponse?
    
    init(
        service: ProfileService = .init(),
        authService: any AuthServiceProtocol = AuthServiceTest()
    ) {
        self.service = service
        self.authService = authService
    }
    
    @MainActor
    func getAccountDetails() async {
        do {
            accountDetails = try await authService.getAccountDetails()
        } catch {
            print(error)
        }
    }
}
