//
//  MovieViewModel.swift
//  MovieExplorer
//
//  Created by artus on 03.09.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import RxSwift

class MovieViewModel{
    let disposeBag = DisposeBag()
    
    public func loadData(_ genreId: Int) -> Observable<Resource<[Movie]>>
    {
        let observable = Observable<Resource<[Movie]>>.create( { [unowned self] observer -> Disposable in
            let res: Observable<Resource<[Movie]>> = Repository().getMovies(genreId)
            let disposable = res.subscribe(onNext: { it in
                print("onNext for movie \(it)")
                observer.onNext(it)
            }, onError: { error in
                print("onError for movie \(error)")
                observer.onNext(Resource<[Movie]>.error(msg: error.localizedDescription))
                observer.onCompleted()
            }, onCompleted: {
                observer.onCompleted()
                print("onCompleted for movie")
            }, onDisposed: {
                print("onDisposed for movie")
            })
            disposable.disposed(by: self.disposeBag)
            return Disposables.create()
        })
        return observable
    }
    
}
