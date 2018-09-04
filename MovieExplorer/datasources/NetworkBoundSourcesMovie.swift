//
//  NetworkBoundSourcesMovie.swift
//  MovieExplorer
//
//  Created by artus on 03.09.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import RxSwift

class NetworkBoundSourcesMovie : NetworkBoundSources<[Movie]> {
    
    let genre_id: Int
    
    init(url: String, genre_id: Int) {
        self.genre_id = genre_id
        super.init(url: url)
    }
    
    override func parseData(_ data: Data) throws -> [Movie] {
        let result = try JSONDecoder().decode(MovieResponse.self, from: data )
        return result.results ?? Array()
    }
    
    override func saveNetworkCallResult(data: [Movie]?){
        guard data != nil else {
            print("Error. Movie result is nil ")
            return
        }
        DatabaseAPI.sharedInstance.saveMovies(data!)
    }
    
    override func shouldLoadFromNetwork(data: [Movie]?) -> Bool {
        guard !(data?.isEmpty)! else {
            return true
        }
        return false
    }
    
    override func loadFromDatabase() -> Observable<[Movie]> {
        let allmovies = DatabaseAPI.sharedInstance.getMovies()
        let movies = DatabaseAPI.sharedInstance.getMovies(genre_id: genre_id)
        let observable = Observable<[Movie]>.just(movies)
        return observable
    }
}
