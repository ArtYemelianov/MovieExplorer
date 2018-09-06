//
//  NetworkBoundSourcesImp.swift
//  MovieExplorer
//
//  Created by artus on 03.09.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class NetworkBoundSourcesGenre : NetworkBoundSources<[Genre]> {
    
    override init(url: String) {
        super.init(url: url)
    }
    
    override func parseData(_ data: Data) throws -> [Genre] {
        let result = try JSONDecoder().decode(GenreResponse.self, from: data )
        return result.genres ?? Array()
    }
    
    override func saveNetworkCallResult(data: [Genre]?){
        guard data != nil else {
            print("Error. Genre result is nil ")
            return
        }
        RxDatabaseAPI.init().saveObservableGenres(data!)
            .subscribeOn(AppExecutors.diskIO)
            .subscribe(onCompleted: {
                    print("Success for saveNetworkCallResult Genre")
            })
    }
    
    override func shouldLoadFromNetwork(data: [Genre]?) -> Bool {
        guard !(data?.isEmpty)! else {
            return true
        }
        return false
    }
    
    override func loadFromDatabase() -> Observable<[Genre]> {
        //TODO let array = [Genre(id: 25, name: "TItle"), Genre(id: 25, name: "Avaranges")]
        let observablelist = RxDatabaseAPI.init().getObservableGenres()
        let observable = Observable<[Genre]>.just(Array())
        return observablelist
    }
}
