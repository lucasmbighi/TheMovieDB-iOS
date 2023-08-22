//
//  ProfileViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    
    let service: ProfileService
    let authService: any AuthServiceProtocol
    
    init(
        service: ProfileService = .init(),
        authService: AuthService = .shared
    ) {
        self.service = service
        self.authService = authService
    }
    
    func getAccountDetails() async {
        do {
            let accountDetails = try await authService.getAccountDetails()
            print(accountDetails)
            
//            if loginResponse.success {
//                print("Sucesso")
//            }
        } catch {
            print(error)
        }
    }
}
