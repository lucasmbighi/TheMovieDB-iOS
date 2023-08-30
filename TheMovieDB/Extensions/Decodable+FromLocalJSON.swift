//
//  Decodable+FromLocalJSON.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation

extension Decodable {
    static var fromLocalJSON: Self? {
        let jsonName = String(describing: self)
        guard let path = Bundle.main.path(forResource: jsonName, ofType: "json") else {
            print("Unable to find a file named \(jsonName)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print("Unable to get the file named \(jsonName).\n\(error)")
            return nil
        }
    }
}
