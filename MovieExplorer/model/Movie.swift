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
    var vote_average :Float
    var title: String
    var poster_path :String?
    var backdrop_path: String?
    var overview: String
    var release_date: String
    var genre_ids: [Int]
    
    init(builder: Builder) {
        self.id = builder.id!
        self.vote_average = builder.vote_average!
        self.title = builder.title!
        self.poster_path = builder.poster_path
        self.backdrop_path = builder.backdrop_path
        self.overview = builder.overview!
        self.release_date = builder.release_date!
        self.genre_ids = builder.genre_ids!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JsonKeys.self)
        try container.encode(self.id, forKey: JsonKeys.id)
        try container.encode(self.vote_average, forKey: JsonKeys.vote_average)
        try container.encode(self.title, forKey: JsonKeys.title)
        try container.encodeIfPresent(self.poster_path, forKey: JsonKeys.poster_path)
        try container.encodeIfPresent(self.backdrop_path, forKey: JsonKeys.backdrop_path)
        try container.encode(self.overview, forKey: JsonKeys.overview)
        try container.encode(self.release_date, forKey: JsonKeys.release_date)
        try container.encode(self.genre_ids, forKey: JsonKeys.genres)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JsonKeys.self)
        self.id = try values.decode(Int.self, forKey: JsonKeys.id)
        self.vote_average  = try values.decode(Float.self, forKey: JsonKeys.vote_average)
        self.title  = try values.decode(String.self, forKey: JsonKeys.title)
        self.backdrop_path  = try values.decodeIfPresent(String.self, forKey: JsonKeys.backdrop_path)
        self.poster_path  = try values.decodeIfPresent(String.self, forKey: JsonKeys.poster_path)
        self.overview  = try values.decode(String.self, forKey: JsonKeys.overview)
        self.release_date  = try values.decode(String.self, forKey: JsonKeys.release_date)
        self.genre_ids  = try values.decode([Int].self, forKey: JsonKeys.genre_ids)
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
    
    class Builder{
        fileprivate var id:Int?
        fileprivate var vote_average :Float?
        fileprivate var title: String?
        fileprivate var poster_path :String?
        fileprivate var backdrop_path: String?
        fileprivate var overview: String?
        fileprivate var release_date: String?
        fileprivate var genre_ids: [Int]?
        
        init(){
            // do nothing
        }
        
        func id(_ id : Int) -> Builder {
            self.id = id
            return self
        }
        
        func vote_average(_ vote_average : Float) -> Builder {
            self.vote_average = vote_average
            return self
        }
        func title(_ title : String) -> Builder {
            self.title = title
            return self
        }
        func poster_path(_ poster_path : String?) -> Builder {
            self.poster_path = poster_path
            return self
        }
        func backdrop_path(_ backdrop_path : String?) -> Builder {
            self.backdrop_path = backdrop_path
            return self
        }
        func overview(_ overview : String) -> Builder {
            self.overview = overview
            return self
        }
        
        func release_date(_ release_date : String) -> Builder {
            self.release_date = release_date
            return self
        }
        
        func genres_ids(str : String) -> Builder {
            var str_ids: [String] = str.components(separatedBy: ",")
            self.genre_ids = str_ids.map{value in Int(value.trimmingCharacters(in: .whitespaces))!}
            return self
        }
        
        func genres_ids(_ genre_ids : [Int]) -> Builder {
            self.genre_ids = genre_ids
            return self
        }
        
        var build: Movie {
            return Movie(builder: self)
        }
    }
}

extension Movie: CustomStringConvertible {
    var description: String {
        return "id: \(self.id), title: \(self.title)"
    }
}
