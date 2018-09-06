//
//  RxDatabaseAPI.swift
//  MovieExplorer
//
//  Created by artus on 06.09.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import RxSwift

class RxDatabaseAPI {
    
    private lazy var api: DatabaseAPI = DatabaseAPI.sharedInstance
    
    func getObservableMovie(id: Int) -> Observable<Movie?> {
        return Observable<Movie?>.create({ observer -> Disposable in
            let movie = self.api.getMovie(id: id)
            observer.onNext(movie)
            observer.onCompleted()
            return Disposables.create {
                print("DatabaseAPI getObservableMovie disposed")
            }
        })
    }
    
    /**
     Retrieve list of movies by genre id
     
     - Parameter genre_id: Id of genre
     - Returns: list of movies
     */
    func getObservableMovies(genre_id: Int) -> Observable<[Movie]> {
        return Observable<[Movie]>.create({ observer -> Disposable in
            let movies = self.api.getMovies(genre_id: genre_id)
            observer.onNext(movies)
            observer.onCompleted()
            return Disposables.create {
                print("DatabaseAPI getObservableMovies disposed")
            }
        })
    }
    
    func getObservableMovies() -> Observable<[Movie]> {
        return Observable<[Movie]>.create({ observer -> Disposable in
            let movies = self.api.getMovies()
            observer.onNext(movies)
            observer.onCompleted()
            return Disposables.create {
                print("DatabaseAPI getMovies disposed")
            }
        })
    }
    
    
    /**
     Stores movies
     
     - Parameter movies: Stores list of movies
     */
    func saveObservableMovies(_ movies: [Movie], for genre_id: Int = -1) -> Observable<Void>{
        return Observable<Void>.create({ observer -> Disposable in
            self.api.saveMovies(movies, for: genre_id)
            observer.onCompleted()
            return Disposables.create {
                print("DatabaseAPI saveObservableMovies disposed")
            }
        })
    }
    
    /**
     Stores genre list
     
     - Parameter genres: List of genres
     */
    func saveObservableGenres(_ genres: [Genre]) -> Observable<Void> {
        return Observable<Void>.create({ observer -> Disposable in
            self.api.saveGenres(genres)
            observer.onCompleted()
            return Disposables.create {
                print("DatabaseAPI saveGenres disposed")
            }
        })
    }
    
    /**
     Retrieves all genre items which are stored
     
     - Returns: Array of stored genres
     */
    func getObservableGenres() -> Observable<[Genre]> {
        return Observable<[Genre]>.create({ observer -> Disposable in
            let genres = self.api.getGenres()
            observer.onNext(genres)
            observer.onCompleted()
            return Disposables.create {
                print("DatabaseAPI getGenres disposed")
            }
        })
    }
    
}
