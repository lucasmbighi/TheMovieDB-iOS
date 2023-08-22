//
//  LoginViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

protocol LoginViewModelProtocol {
    var isLoading: Bool { get set }
    var username: String { get set }
    var password: String { get set }
    var errorMessage: String? { get set }
    var authService: any AuthServiceProtocol { get set }
    
    func login() async
}

final class LoginViewModel: LoginViewModelProtocol, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String? = nil
    
    var authService: any AuthServiceProtocol
    
    init(
        authService: any AuthServiceProtocol = AuthService.shared
    ) {
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

//MARK: Computed properties
extension LoginViewModel {
    var hasBiometry: Bool { authService.hasBiometry }
}
