//
//  TabBarView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selectedIndex = 0
    
    let items: [TabBarItem]
    
    var body: some View {
        ZStack {
            pages
            tabBar
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func isSelected(_ index: Int) -> Bool { selectedIndex == index }
    private func selectIndex(_ index: Int) {
        withAnimation {
            selectedIndex = index
        }
    }
    
    private var tabBar: some View {
        VStack {
            Spacer()
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    TabBarItemView(
                        item: items[index],
                        index: index,
                        isSelected: isSelected(index),
                        onSelect: { selectedIndex in
                            selectIndex(selectedIndex)
                        }
                    )
                    .padding(5)
                }
            }
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .cornerRadius(50)
            .padding(16)
            .animation(.easeIn, value: selectedIndex)
        }
    }
    
    private var pages: some View {
        VStack {
            ForEach(0..<items.count, id: \.self) { index in
                let view = items[index].content
                AnyView(view)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        )
                    )
                    .isHidden(!isSelected(index))
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TabBarView(items: [
                TabBarItem(
                    name: "Home",
                    icon: Image(systemName: "house"),
                    selectedIcon: Image(systemName: "house.fill"),
                    color: .blue,
                    content: MovieListView(viewModel: .init())
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
        }
        .preferredColorScheme(.light)
    }
}

struct TabBarItem: Identifiable {
    var id: UUID = UUID()
    let name: String
    let icon: Image
    let selectedIcon: Image
    let color: Color
    let content: any View
}

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
                .frame(width: 30, height: 30)
            Spacer()
                .isHidden(!isSelected)
            Text(item.name)
                .font(.system(size: 16, weight: .bold))
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
