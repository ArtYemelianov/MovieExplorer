//
//  EntityTypes.swift
//  MovieExplorer
//
//  Created by artus on 05.09.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation

enum EntityTypes: String {
        case Movie = "Movie"
        case Genre = "Genre"
    
    static let getAll = [Genre, Movie]
}
