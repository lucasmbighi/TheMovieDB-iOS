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
    var showCredentialView: Bool { get set }
    var authenticator: Authenticator { get set }
    
    init(authenticator: Authenticator)
    
    func login() async
    func loginWithBiometry() async
    func showCredentialLoginView()
}

final class LoginViewModel: LoginViewModelProtocol, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String? = nil
    @Published var showCredentialView: Bool = false
    
    var authenticator: Authenticator
    
    init(authenticator: Authenticator = .shared) {
        self.authenticator = authenticator
    }
    
    @MainActor
    func login() async {
        isLoading = true
        do {
            try await authenticator.authenticate(username: username, password: password)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        isLoading = false
    }
    
    @MainActor
    func loginWithBiometry() async {
        isLoading = true
        do {
            try await authenticator.authenticateWithBiometry()
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        isLoading = false
    }
    
    func showCredentialLoginView() {
        showCredentialView = true
    }
}

//MARK: Computed properties
extension LoginViewModel {
    var buttonTitle: String {
        guard let name = authenticator.name else { return "Login with another account" }
        return "I'm not \(name)"
    }
    
    var viewTitle: String {
        guard let name = authenticator.name else { return "Hello" }
        return "Hello, \(name)"
    }
}
