//
//  Movie.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    let genre: [String]
    let releaseYear: Int
    let title: String
    let image: String
    let rating: Double
    
}

extension Movie {
    
    var released: String {
        return "\(self.releaseYear)"
    }
}
