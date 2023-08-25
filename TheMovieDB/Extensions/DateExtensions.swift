//
//  Date+Formatter.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 25/08/23.
//

import Foundation

//MARK: Extension - Component
extension Date {
    func component(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    
}

//MARK: Extension - years
extension Date {
    func years(from year: Int) -> [Int] {
        (year...self.component(.year)).map { $0 }.reversed()
    }
}
