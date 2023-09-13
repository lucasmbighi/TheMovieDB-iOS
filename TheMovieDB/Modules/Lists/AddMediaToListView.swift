//
//  AddMediaToListView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 05/09/23.
//

import SwiftUI

struct AddMediaToListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
            
            Group {
                VStack {
                    HStack {
                        Spacer()
                        Text("lists.new_list".localized).bold()
                        Spacer()
                        Button {
                            viewModel.showNewListAlert = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Picker(selection: $viewModel.selectedList, label: EmptyView()) {
                            Text("lists.select_a_list".localized)
                                .tag(nil as ListResponse?)
                            ForEach(viewModel.lists) { list in
                                Text(list.name)
                                    .tag(list as ListResponse?)
                            }
                        }
                    }
                    
                    HStack {
                        Button {
                            Task {
                                await viewModel.addToSelectedList()
                            }
                            dismiss()
                        } label: {
                            Text("OK")
                            
                        }
                        Spacer()
                        Button(action: dismiss.callAsFunction) {
                            Text("lists.cancel".localized).bold()
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.white)
                .cornerRadius(16)
            }
            .padding(60)
        }
        .ignoresSafeArea()
        .task {
            await viewModel.fetchLists()
            viewModel.checkLists()
        }
        .alert("lists.create_list".localized, isPresented: $viewModel.showNewListAlert) {
            CreateListView()
        }
    }
}

struct AddMediaToListView_Previews: PreviewProvider {
    static var previews: some View {
        AddMediaToListView(viewModel: .init())
    }
}
