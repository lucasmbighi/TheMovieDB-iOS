//
//  Date.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "YYYY-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
