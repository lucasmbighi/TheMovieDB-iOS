//
//  LoginViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

protocol LoginViewModelProtocol {
    var viewState: ViewState { get set }
    var username: String { get set }
    var password: String { get set }
    var errorMessage: String? { get set }
    var authService: any AuthServiceProtocol { get set }
    
    func login() async
}

final class LoginViewModel: LoginViewModelProtocol, ObservableObject {
    @Published var viewState: ViewState = .ready
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
        viewState = .loading
        do {
            try await authService.authenticate(username: username, password: password)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        viewState = .ready
    }
}
