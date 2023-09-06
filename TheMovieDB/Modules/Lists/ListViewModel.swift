//
//  ListViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 05/09/23.
//

import Foundation
import SwiftUI

protocol ListViewModelProtocol {
    var lists: [ListResponse] { get set }
    var showNewListAlert: Bool { get set }
    var newListName: String { get set }
    var newListDescription: String { get set }
    var isLoading: Bool { get set }
    var selectedList: ListResponse? { get set }
    
    var profileService: any ProfileServiceProtocol { get set }
    var authenticator: Authenticator { get set }
    var media: MediaResponse? { get set }
    var onCreateList: ((_ success: Bool) -> Void)? { get set }
    
    init(
        profileService: any ProfileServiceProtocol,
        authenticator: Authenticator,
        media: MediaResponse?,
        onCreateList: ((_ success: Bool) -> Void)?
    )
    
    func fetchLists() async
    func createList() async
    func addToSelectedList() async
    func delete(_ list: ListResponse) async
    func checkLists()
}

final class ListViewModel: ListViewModelProtocol, ObservableObject {
    @Published var lists: [ListResponse] = []
    @Published var showNewListAlert: Bool = false
    @Published var newListName: String = ""
    @Published var newListDescription: String = ""
    @Published var isLoading: Bool = false
    @Published var selectedList: ListResponse? = nil
    
    var profileService: any ProfileServiceProtocol
    var authenticator: Authenticator
    var media: MediaResponse?
    var onCreateList: ((_ success: Bool) -> Void)?
    
    init(
        profileService: any ProfileServiceProtocol = ProfileService(),
        authenticator: Authenticator = .shared,
        media: MediaResponse? = nil,
        onCreateList: ((_ success: Bool) -> Void)? = nil
    ) {
        self.profileService = profileService
        self.authenticator = authenticator
        self.media = media
        self.onCreateList = onCreateList
    }
    
    @MainActor
    func fetchLists() async {
        isLoading = true
        do {
            let accountId = try await authenticator.getAccountDetails().id
            lists = try await profileService.getLists(accountId: accountId).results
        } catch {
            
        }
        isLoading = false
    }
    
    @MainActor
    func createList() async {
        isLoading = true
        do {
            guard let sessionId = authenticator.sessionId else { return }
            let request = CreateListRequest(name: newListName, description: newListDescription)
            let response: CreateListResponse = try await profileService.createList(sessionId: sessionId, request: request)
            onCreateList?(response.success)
            if !response.success {
                //                errorMessage = response.statusMessage
            }
        } catch {
            //            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func addToSelectedList() async {
        guard let selectedList, let media else { return }
        do {
            guard let sessionId = authenticator.sessionId else { return }
            let response: RequestResponse = try await profileService.addToList(selectedList, media: media, sessionId: sessionId)
            if !response.success {
                //                errorMessage = response.statusMessage
            }
        } catch {
            //            errorMessage = error.localizedDescription
        }
    }
    
    func delete(_ list: ListResponse) async {
        do {
            guard let sessionId = authenticator.sessionId else { return }
            let response: RequestResponse = try await profileService.deleteList(list, sessionId: sessionId)
            if !response.success {
                //                errorMessage = response.statusMessage
            }
        } catch {
            //            errorMessage = error.localizedDescription
        }
    }
    
    func checkLists() {
        showNewListAlert = lists.isEmpty
    }
}
