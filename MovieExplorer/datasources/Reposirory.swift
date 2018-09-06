//
//  Reposirory.swift
//  MovieExplorer
//
//  Created by artus on 31.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import RxSwift

class Repository{
    fileprivate static let movie_url = "https://api.themoviedb.org/3/discover/movie?api_key=\(AppKeys.API_KEY)"
    fileprivate static let genre_url: String = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(AppKeys.API_KEY)"
    static func compose_image_url(for url: String) -> String {
        return "https://image.tmdb.org/t/p/w600_and_h900_bestv2/\(url)"
    }
    
    fileprivate static func composeMovieUrl(genreId: Int) -> String {
        return "\(movie_url)&with_genres=\(genreId)"
    }
    
    func getGenres() -> Observable<Resource<[Genre]>>{
        return NetworkBoundSourcesGenre(url: Repository.genre_url).asObservable
    }
    
    func getMovies(_ genreId: Int) -> Observable<Resource<[Movie]>>{
        let url = Repository.composeMovieUrl(genreId: genreId)
        return NetworkBoundSourcesMovie(url: url, genre_id: genreId).asObservable
    }

}
