//
//  AccountDetailResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

struct AccountDetailResponse: Decodable {
    let avatar: Avatar
    let id: Int
    let name: String
    let username: String
}

extension AccountDetailResponse {
    struct Avatar: Decodable {
        struct TMDB: Decodable {
            let avatarPath: String
            
            enum CodingKeys: String, CodingKey {
                case avatarPath = "avatar_path"
            }
        }
        
        let tmdb: TMDB
    }
}
