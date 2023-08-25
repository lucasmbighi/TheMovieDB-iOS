//
//  TabBarItem.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 24/08/23.
//

import SwiftUI

struct TabBarItem {
    let name: String
    let icon: Image
    let selectedIcon: Image
    let color: Color
    let content: any View
}

extension TabBarItem: Identifiable {
    var id: UUID { UUID() }
}
