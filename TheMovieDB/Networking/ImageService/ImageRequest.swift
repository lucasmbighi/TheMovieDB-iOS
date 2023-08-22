//
//  ImageRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation

struct ImageRequest {
    let type: ImageType
    let path: String
}

extension ImageRequest {
    enum ImageType {
        case backdrop(BackdropSize), logo(LogoSize), poster(PosterSize), profile(ProfileSize), still(StillSize)
        
        enum BackdropSize: String {
            case w300, w780, w1280, original
        }
        
        enum LogoSize: String {
            case w45, w92, w154, w185, w300, w500, original
        }
        
        enum PosterSize: String {
            case w92, w154, w185, w342, w500, w780, original
        }
        
        enum ProfileSize: String {
            case w45, w185, h632, original
        }
        
        enum StillSize: String {
            case w92, w185, w300, original
        }
        
        var size: String {
            switch self {
            case .backdrop(let size): return size.rawValue
            case .logo(let size): return size.rawValue
            case .poster(let size): return size.rawValue
            case .profile(let size): return size.rawValue
            case .still(let size): return size.rawValue
            }
        }
        
        var placeholderName: String {
            switch self {
            case .backdrop: return "backdrop-placeholder"
            case .logo: return "logo-placeholder"
            case .poster: return "poster-placeholder"
            case .profile: return "profile-placeholder"
            case .still: return "still-placeholder"
            }
        }
    }
}

extension ImageRequest: RequestType {
    var urlHost: String { "image.tmdb.org" }
    var urlPath: String { "/t/p/\(type.size)\(path)" }
    var method: HTTPMethod { .get }
    var parameters: Parameter? { nil }
}
