//
//  ListsView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 05/09/23.
//

import SwiftUI

struct ListsView: View {
    
    @ObservedObject private var viewModel: ListViewModel
    
    init(viewModel: ListViewModel = .init()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.lists) { list in
                        NavigationLink {
                            Text(list.name)
                        } label: {
                            Text(list.name)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        Task {
                                            await viewModel.delete(list)
                                        }
                                    } label: {
                                        Label("lists.delete".localized, systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
            }
            .toolbar {
                Button {
                    viewModel.showNewListAlert = true
                } label: {
                    Text("lists.new_list".localized)
                }
            }
            .navigationTitle("lists.my_lists".localized)
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await viewModel.fetchLists()
        }
        .alert("lists.new_list".localized, isPresented: $viewModel.showNewListAlert) {
            CreateListView(viewModel: .init(onCreateList: { success in
                if success {
                    Task {
                        await viewModel.fetchLists()
                    }
                }
            }))
        }
        .globalMessage($viewModel.globalMessage)
    }
}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
    }
}
