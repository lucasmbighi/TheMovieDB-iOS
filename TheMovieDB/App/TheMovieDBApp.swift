//
//  TheMovieDBApp.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import SwiftUI
import TabBar

@main
struct TheMovieDBApp: App {
    
    @ObservedObject private var authenticator: Authenticator
    
    init() {
        self.authenticator = .shared
    }
    
    var body: some Scene {
        WindowGroup {
            if authenticator.isLoggedIn {
                rootView
            } else {
                if authenticator.hasBiometry {
                    BiometryLoginView()
                } else {
                    CredentialLoginView()
                }
            }
        }
    }
    
    private var rootView: some View {
        TabBarView(items: [
            TabBarItem(
                name: "Home",
                icon: Image(systemName: "house"),
                selectedIcon: Image(systemName: "house.fill"),
                color: .blue,
                content: MediaListView()
            ),
            TabBarItem(
                name: "My Lists",
                icon: Image(systemName: "bookmark"),
                selectedIcon: Image(systemName: "bookmark.fill"),
                color: .yellow,
                content: ListsView()
            ),
            TabBarItem(
                name: "Profile",
                icon: Image(systemName: "person"),
                selectedIcon: Image(systemName: "person.fill"),
                color: .green,
                content: ProfileView()
            )
        ])
    }
}
