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
    var showCredentialView: Bool { get set }
    var authenticator: Authenticator { get set }
    var globalMessage: GlobalMessage? { get set }
    
    init(authenticator: Authenticator)
    
    func login() async
    func loginWithBiometry() async
    func showCredentialLoginView()
}

final class LoginViewModel: LoginViewModelProtocol, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showCredentialView: Bool = false
    @Published var globalMessage: GlobalMessage?
    
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
            globalMessage = .init(from: error)
        }
        isLoading = false
    }
    
    @MainActor
    func loginWithBiometry() async {
        isLoading = true
        do {
            try await authenticator.authenticateWithBiometry()
        } catch {
            globalMessage = .init(from: error)
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
        guard let name = authenticator.name else { return "login.login_with_another_account".localized }
        return "login.im_not".localized(name)
    }
    
    var viewTitle: String {
        guard let name = authenticator.name else { return "login.hello".localized }
        return "login.hello_name".localized(name)
    }
}
