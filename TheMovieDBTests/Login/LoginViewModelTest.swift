//
//  LoginViewModelTest.swift
//  TheMovieDBTests
//
//  Created by Lucas Bighi on 16/08/23.
//

import Foundation
@testable import TheMovieDB

final class LoginViewModelTest: LoginViewModelProtocol {
    
    var isLoading: Bool = false
    var username: String = ""
    var password: String = ""
    var errorMessage: String?
    
    var authService: any TheMovieDB.AuthServiceProtocol
    
    init(authService: any TheMovieDB.AuthServiceProtocol = AuthServiceTest()) {
        self.authService = authService
    }
    
    @MainActor
    func login() async {
        isLoading = true
        do {
            try await authService.authenticate(username: username, password: password)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        isLoading = false
    }
    
    @MainActor
    func loginWithBiometry() async {
        isLoading = true
        do {
            try await authService.authenticateWithBiometry()
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        isLoading = false
    }
}
