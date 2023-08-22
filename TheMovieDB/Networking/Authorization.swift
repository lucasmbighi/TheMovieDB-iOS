//
//  Authorization.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

enum Authorization {
    case basic
    case bearer
    
    var rawValue: String {
        switch self {
        case .basic:
            return "Basic"
        case .bearer:
            guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Api Key") as? String, !apiKey.isEmpty else {
                fatalError("Unable to get Api Key value from Info.plist. Please, check.")
            }
            return "Bearer \(apiKey)"
        }
    }
}
