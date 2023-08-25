//
//  TabBarItemView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 24/08/23.
//

import SwiftUI

struct TabBarItemView: View {
    
    let item: TabBarItem
    let index: Int
    let isSelected: Bool
    let onSelect: (Int) -> Void
    
    var body: some View {
        HStack {
            (isSelected ? item.selectedIcon : item.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
            Spacer()
                .isHidden(!isSelected)
            Text(item.name)
                .font(.system(size: 14, weight: .medium))
                .isHidden(!isSelected)
            Spacer()
                .isHidden(!isSelected)
        }
        .onTapGesture {
            onSelect(index)
        }
        .foregroundColor(isSelected ? .white : item.color)
        .padding(14)
        .background(item.color.opacity(isSelected ? 1 : 0.2))
        .cornerRadius(30)
    }
}

struct TabBarItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarItemView(
            item: TabBarItem(
                name: "Profile",
                icon: Image(systemName: "person"),
                selectedIcon: Image(systemName: "person.fill"),
                color: .green,
                content: ProfileView(viewModel: .init())
            ),
            index: 0,
            isSelected: true,
            onSelect: { _ in }
        )
    }
}
