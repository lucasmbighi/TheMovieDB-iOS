//
//  CastResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 30/08/23.
//

import Foundation

struct CastResponse: Identifiable, Decodable {
    let id: Int
    let knownForDepartment: Department?
    let name: String
    let profilePath: String?
    let character: String
}

////MARK: enum Department
//extension CastResponse: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case id, knownForDepartment, name, profilePath, charac
//    }
//}

//MARK: enum Department
extension CastResponse {
    enum Department: String, Decodable {
        case acting = "Acting",
             visualEffects = "Visual Effects",
             writing = "Writing",
             production = "Production",
             directing = "Directing",
             sound = "Sound",
             art = "Art",
             costumeAndMakeUp = "Costume & Make-Up",
             camera = "Camera",
             editing = "Editing",
             crew = "Crew"
    }
}
