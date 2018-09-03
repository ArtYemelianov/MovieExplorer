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
    
    override init(url: String) {
        super.init(url: url)
    }
    
    override func parseData(_ data: Data) throws -> [Movie] {
        let result = try JSONDecoder().decode(MovieResponse.self, from: data )
        return result.results ?? Array()
    }
    
    override func saveNetworkCallResult(data: [Movie]?){
        //TODO store result in storage
    }
    
    override func shouldLoadFromNetwork(data: [Movie]?) -> Bool {
        guard !(data?.isEmpty)! else {
            return true
        }
        return false
    }
    
    override func loadFromDatabase() -> Observable<[Movie]> {
        let observable = Observable<[Movie]>.just(Array())
        return observable
    }
}
