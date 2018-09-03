//
//  Movie.swift
//  MovieExplorer
//
//  Created by artus on 03.09.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation

final class Movie: Codable, Equatable, Hashable {
    
    var id:Int
//    var vote_average :Int
    var title: String
//    var poster_path :String
//    var backdrop_path: String
//    var overview: String
//    var release_date: String
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JsonKeys.self)
        try container.encode(self.id, forKey: JsonKeys.id)
//        try container.encode(self.vote_average, forKey: JsonKeys.vote_average)
        try container.encode(self.title, forKey: JsonKeys.title)
//        try container.encode(self.poster_path, forKey: JsonKeys.poster_path)
//        try container.encode(self.overview, forKey: JsonKeys.overview)
//        try container.encode(self.release_date, forKey: JsonKeys.release_date)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JsonKeys.self)
        self.id = try values.decode(Int.self, forKey: JsonKeys.id)
//        self.vote_average  = try values.decode(Int.self, forKey: JsonKeys.vote_average)
        self.title  = try values.decode(String.self, forKey: JsonKeys.title)
//        self.backdrop_path  = try values.decode(String.self, forKey: JsonKeys.backdrop_path)
//        self.poster_path  = try values.decode(String.self, forKey: JsonKeys.poster_path)
//        self.overview  = try values.decode(String.self, forKey: JsonKeys.overview)
//        self.release_date  = try values.decode(String.self, forKey: JsonKeys.release_date)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        var result = true
        result = result && lhs.id == rhs.id
        result = result && lhs.title  == rhs.title
        return result
    }
    
    var hashValue: Int {
        get {
            return id.hashValue  ^ title.hashValue
        }
    }
}

extension Movie: CustomStringConvertible {
    var description: String {
        return "id: \(self.id), title: \(self.title)"
    }
}
