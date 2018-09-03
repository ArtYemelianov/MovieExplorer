//
//  MovieResponse.swift
//  MovieExplorer
//
//  Created by artus on 03.09.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation

final class MovieResponse: Decodable, Equatable, CustomStringConvertible {
    
    var page: Int
    var results : [Movie]?
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JsonKeys.self)
        self.page = try values.decode(Int.self, forKey: JsonKeys.page)
        self.results = try values.decode([Movie].self, forKey: JsonKeys.results)
    }
    
    var description: String {
        return "genres: \(results?.description ?? "nil")"
    }
    
    static func ==(lhs: MovieResponse, rhs: MovieResponse) -> Bool {
        return lhs.page == rhs.page
    }
}
