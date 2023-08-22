//
//  Decodable+FromLocalJSON.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation

extension Decodable {
    static var fromLocalJSON: Self {
        let jsonName = String(describing: self)
        guard let path = Bundle.main.path(forResource: jsonName, ofType: "json") else {
            fatalError("Unable to find a file named \(jsonName)")
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            fatalError("Unable to get the file named \(jsonName).\n\(error)")
        }
    }
}
