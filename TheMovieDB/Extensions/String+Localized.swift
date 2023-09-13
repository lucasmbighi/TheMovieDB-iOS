//
//  String+Localized.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/09/23.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localized(_ args: CVarArg...) -> String {
        String(format: localized, args)
    }
}
