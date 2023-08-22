//
//  NetworkError.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

enum NetworkError: Error {
    case malformatedURL
    case decodeError
    case invalidResponse
    case httpError(Int)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .malformatedURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL error")
        case .decodeError:
            return NSLocalizedString("Invalid object", comment: "Invalid object error")
        case .invalidResponse:
            return NSLocalizedString("Invalid response", comment: "Invalid response error")
        case .httpError(let statusCode):
            switch statusCode {
            case 400..<500:
                return NSLocalizedString("Authorization error", comment: "Authorization error")
            case 500..<600:
                return NSLocalizedString("Server error", comment: "Server error")
            default:
                return NSLocalizedString("Unknown error", comment: "Unknown error")
            }
        }
    }
}
