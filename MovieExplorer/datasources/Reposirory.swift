//
//  Reposirory.swift
//  MovieExplorer
//
//  Created by artus on 31.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import RxSwift

class Repository<Element>{
    
    func getGenres(for url: String) -> Observable<Resource<Element>>{
        if Element.self  == [Genre].self {
            let array = [Genre(id: 25, name: "TItle"), Genre(id: 25, name: "Avaranges")]
            let el : Element = array as! Element
            let success = Resource<Element>.success(data: el)
            return Observable.just(success)
        }
        return nil!
    }
}
