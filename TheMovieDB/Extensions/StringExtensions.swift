//
//  String.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

//MARK: Extension - Identifiable
extension String: Identifiable {
    public var id: String { self }
}

//MARK: Extension - DropdownItemProtocol
extension String: DropdownItemProtocol {
    public var optionTitle: String { self }
}

//MARK: Extension - toDate(withFormat:) -> Date?
extension String {
    func toDate(withFormat format: String = "YYYY-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
