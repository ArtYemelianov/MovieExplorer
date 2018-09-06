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
        RxDatabaseAPI.init().saveObservableMovies(data!)
            .subscribeOn(AppExecutors.diskIO)
            .subscribe(onCompleted: {
                print("Success for saveNetworkCallResult Movie")
            })
    }
    
    override func shouldLoadFromNetwork(data: [Movie]?) -> Bool {
        return true
    }
    
    override func loadFromDatabase() -> Observable<[Movie]> {
        return RxDatabaseAPI.init().getObservableMovies(genre_id: genre_id)
    }
}
