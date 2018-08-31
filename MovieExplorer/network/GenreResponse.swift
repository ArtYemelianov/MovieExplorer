//
//  GenreResponse.swift
//  MovieExplorer
//
//  Created by artus on 31.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation

final class GenreResponse: Decodable, Equatable, CustomStringConvertible {
    
    var genres: [Genre]?
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JsonKeys.self)
        self.genres = try values.decode([Genre].self, forKey: JsonKeys.genres)
    }
    
    var description: String {
        return "genres: \(genres?.description ?? "nil")"
    }
    
    static func ==(lhs: GenreResponse, rhs: GenreResponse) -> Bool {
        return lhs.genres == rhs.genres
    }
}
