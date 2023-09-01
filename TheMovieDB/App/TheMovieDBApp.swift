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
                TabBarView(items: [
                    TabBarItem(
                        name: "Home",
                        icon: Image(systemName: "house"),
                        selectedIcon: Image(systemName: "house.fill"),
                        color: .blue,
                        content: MediaListView(viewModel: .init())
                    ),
                    TabBarItem(
                        name: "My Lists",
                        icon: Image(systemName: "bookmark"),
                        selectedIcon: Image(systemName: "bookmark.fill"),
                        color: .yellow,
                        content: Text("My Lists will appear here")
                    ),
                    TabBarItem(
                        name: "Profile",
                        icon: Image(systemName: "person"),
                        selectedIcon: Image(systemName: "person.fill"),
                        color: .green,
                        content: ProfileView(viewModel: .init())
                    )
                ])
            } else {
                LoginView(viewModel: .init())
            }
        }
    }
}
