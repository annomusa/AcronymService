//
//  Acronym.swift
//  KituraTIL
//
//  Created by Muhammad Aunorafiq Musa on 11/07/18.
//

import Foundation

struct Acronym: Codable {
    
    var id: String?
    var short: String
    var long: String
    
    init?(id: String?, short: String, long: String) {
        
        if short.isEmpty || long.isEmpty {
            return nil
        }
        self.id = id
        self.short = short
        self.long = long
    }
}

extension Acronym: Equatable {
    
    public static func ==(lhs: Acronym, rhs: Acronym) -> Bool {
        return lhs.short == rhs.short && lhs.long == rhs.long
    }
}
