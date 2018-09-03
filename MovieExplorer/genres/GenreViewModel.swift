//
//  GenreViewModel.swift
//  MovieExplorer
//
//  Created by artus on 31.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import RxSwift

class GenreViewModel{
    fileprivate static let url: String = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(AppKeys.API_KEY)"
    let disposeBag = DisposeBag()
    
    public func loadData() -> Observable<Resource<[Genre]>>
    {
        let observable = Observable<Resource<[Genre]>>.create( { [unowned self] observer -> Disposable in
            let res: Observable<Resource<[Genre]>> = Repository<[Genre]>().getGenres(for: GenreViewModel.url)
            let disposable = res.subscribe(onNext: { it in
                print("onNext for genre \(it)")
                observer.onNext(it)
            }, onError: { error in
                print("onError for genre \(error)")
                observer.onNext(Resource<[Genre]>.error(msg: error.localizedDescription))
                observer.onCompleted()
            }, onCompleted: {
                observer.onCompleted()
                print("onCompleted for genre")
            }, onDisposed: {
                print("onDisposed for genre")
            })
            disposable.disposed(by: self.disposeBag)
            return Disposables.create()
        })
        return observable
    }
    
}


