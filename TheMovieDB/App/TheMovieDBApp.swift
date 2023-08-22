//
//  TheMovieDBApp.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import SwiftUI

@main
struct TheMovieDBApp: App {
    
    @ObservedObject private var authService: AuthService
    
    init() {
        self.authService = .shared
    }
    
    var body: some Scene {
        WindowGroup {
            if authService.isLoggedIn {
                MovieListView(viewModel: .init())
            } else {
                LoginView(viewModel: .init())
            }
        }
    }
}
