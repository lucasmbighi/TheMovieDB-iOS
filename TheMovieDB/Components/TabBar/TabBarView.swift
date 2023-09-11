//
//  TabBarView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var currentIndex: Int = 0
    @State private var insertionTransitionEdge: Edge = .trailing
    @State private var removalTransitionEdge: Edge = .leading
    
    let items: [TabBarItem]
    
    var body: some View {
        ZStack {
            pages
            tabBar
                .ignoresSafeArea(edges: .bottom)
        }
    }
    
    private func isSelected(_ index: Int) -> Bool { currentIndex == index }
    private func selectIndex(_ index: Int) {
        withAnimation(.spring()) {
            currentIndex = index
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
                            insertionTransitionEdge = selectedIndex > currentIndex ? .trailing : .leading
                            removalTransitionEdge = selectedIndex > currentIndex ? .leading : .trailing
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
            .animation(.easeIn, value: currentIndex)
        }
    }
    
    private var pages: some View {
        VStack {
            ForEach(0..<items.count, id: \.self) { index in
                let view = items[index].content
                AnyView(view)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: insertionTransitionEdge),
                            removal: .move(edge: removalTransitionEdge)
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
                    content: MediaListView()
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
                    content: ProfileView()
                )
            ])
        }
        .preferredColorScheme(.light)
    }
}

