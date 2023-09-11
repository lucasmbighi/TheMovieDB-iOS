//
//  GlobalMessage.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/09/23.
//

import Foundation

struct GlobalMessage: Identifiable, Equatable {
    let id: UUID = UUID()
    let message: String
    let success: Bool
    
    init(message: String, success: Bool) {
        self.message = message
        self.success = success
    }
    
    init(from error: Error) {
        self.message = "Error: \(error.localizedDescription)"
        self.success = false
    }
}
