//
//  Genre.swift
//  MovieExplorer
//
//  Created by artus on 31.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation

final class Genre: Codable, Equatable, Hashable {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JsonKeys.self)
        try container.encode(self.id, forKey: JsonKeys.id)
        try container.encode(self.name, forKey: JsonKeys.name)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JsonKeys.self)
        self.id = try values.decode(Int.self, forKey: JsonKeys.id)
        self.name  = try values.decode(String.self, forKey: JsonKeys.name)
    }
    
    static func ==(lhs: Genre, rhs: Genre) -> Bool {
        var result = true
        result = result && lhs.id == rhs.id
        result = result && lhs.name  == rhs.name
        return result
    }
    
    var hashValue: Int {
        get {
            return id.hashValue ^ name.hashValue
        }
    }
}

extension Genre: CustomStringConvertible {
    var description: String {
        return "id: \(self.id), name: \(self.name)"
    }
}

