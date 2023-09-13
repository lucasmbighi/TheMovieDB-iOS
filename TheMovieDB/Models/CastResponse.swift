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

//MARK: enum Department
extension CastResponse {
    enum Department: String, Decodable {
        case acting = "mediadetail.acting",
             visualEffects = "mediadetail.visual_effects",
             writing = "mediadetail.writing",
             production = "mediadetail.production",
             directing = "mediadetail.directing",
             sound = "mediadetail.sound",
             art = "mediadetail.art",
             costumeAndMakeUp = "mediadetail.costume_and_make_up",
             camera = "mediadetail.camera",
             editing = "mediadetail.editing",
             crew = "mediadetail.crew"
    }
}
