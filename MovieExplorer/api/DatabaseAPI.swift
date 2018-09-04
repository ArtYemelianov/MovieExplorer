//
//  DatabaseAPI.swift
//  MovieExplorer
//
//  Created by artus on 05.09.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import CoreData

class DatabaseAPI {
    
    fileprivate let persistenceManager: PersistenceManager!
    fileprivate var mainContextInstance: NSManagedObjectContext!
    
    init() {
        self.persistenceManager = PersistenceManager.sharedInstance
        self.mainContextInstance = persistenceManager.getMainContextInstance()
    }
    
    /**
     Retrieve a movie by id
     
     - Parameter id: Id of moview
     - Returns: a found Event item, or nil
     */
    func getMovie(id: Int) -> Movie? {
        var fetchedResult: MovieDao?
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.Movie.rawValue)
        do {
            let fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [MovieDao]
            fetchRequest.fetchLimit = 1
            
            if fetchedResults.count != 0 {
                fetchedResult =  fetchedResults.first
            }
        } catch let fetchError as NSError {
            print("retrieve single event error: \(fetchError.localizedDescription)")
        }
        
        guard let result = fetchedResult else {
            return nil
        }
        return result.toMovie
    }
    
    /**
     Retrieve list of movies by genre id
     
     - Parameter genre_id: Id of genre
     - Returns: list of movies
     */
    func getMovies(genre_id: Int) -> [Movie] {
        var fetchedResults: [MovieDao] = Array()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.Movie.rawValue)
        do {
            // sort by vote_average fetchRequest.sortDescriptors = [ NSSortDescriptor(key: JsonKeys.name.rawValue, ascending: true)]
//            let filter = "\(JsonKeys.genre_ids.rawValue) = %@"
            let filter = "\(JsonKeys.genre_ids.rawValue) CONTAINS[cd] %@"
            fetchRequest.predicate = NSPredicate(format: filter, String(genre_id))
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [MovieDao]
        } catch let fetchError as NSError {
            print("retrieve single event error: \(fetchError.localizedDescription)")
        }
        
        return fetchedResults.map{ value in value.toMovie }
    }
    
    func getMovies() -> [Movie] {
        var fetchedResults: [MovieDao] = [MovieDao]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.Movie.rawValue)
        
        do {
            fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [MovieDao]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = [MovieDao]()
        }
        
        return fetchedResults.map{ value in value.toMovie }
    }
    
    
    /**
     Stores movies
     
     - Parameter movies: Stores list of movies
     */
    func saveMovies(_ movies: [Movie]){
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance
        
        for movie in movies {
            let item = NSEntityDescription.insertNewObject(forEntityName: EntityTypes.Movie.rawValue, into: minionManagedObjectContextWorker) as! MovieDao
            movie.updateMovieDao(item)
            self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        }
        
        self.persistenceManager.mergeWithMainContext()
    }
    
    /**
     Stores genre list
     
     - Parameter genres: List of genres
     */
    func saveGenres(_ genres: [Genre]) {
        
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = self.mainContextInstance
        
        for genre in genres {
            let item = NSEntityDescription.insertNewObject(forEntityName: EntityTypes.Genre.rawValue, into: minionManagedObjectContextWorker) as! GenreDao
            item.setValue(genre.id, forKey: JsonKeys.id.rawValue)
            item.setValue(genre.name, forKey: JsonKeys.name.rawValue)
            self.persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        }
        
        self.persistenceManager.mergeWithMainContext()
    }
    
    /**
     Retrieves all genre items which are stored
     
     - Returns: Array of stored genres
     */
    func getGenres() -> [Genre] {
        var fetchedResults: [GenreDao] = [GenreDao]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.Genre.rawValue)
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: JsonKeys.name.rawValue, ascending: true)]
        
        do {
            fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [GenreDao]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = [GenreDao]()
        }
        
        return fetchedResults.map{ value in Genre(id: Int(value.id), name: value.name!) }
    }
}

extension Movie {
    func updateMovieDao(_ item: MovieDao){
        item.setValue(id, forKey: JsonKeys.id.rawValue)
        item.setValue(title, forKey: JsonKeys.title.rawValue)
        item.setValue(backdrop_path, forKey: JsonKeys.backdrop_path.rawValue)
        item.setValue(poster_path, forKey: JsonKeys.poster_path.rawValue)
        item.setValue(overview, forKey: JsonKeys.overview.rawValue)
        item.setValue(vote_average, forKey: JsonKeys.vote_average.rawValue)
        item.setValue(release_date, forKey: JsonKeys.release_date.rawValue)
        item.setValue(genre_ids.map{ String($0) }.joined(separator: ","), forKey: JsonKeys.genre_ids.rawValue)
    }
}


extension MovieDao {
    var toMovie: Movie{
        return Movie.Builder()
            .id(Int(id))
            .vote_average(vote_average)
            .title(title!)
            .poster_path(poster_path!)
            .backdrop_path(backdrop_path)
            .overview(overview!)
            .release_date(release_date!)
            .genres_ids(str: genre_ids!)
            .build
    }
}


extension DatabaseAPI {
    class var sharedInstance: DatabaseAPI {
        struct Singleton {
            static let instance = DatabaseAPI()
        }
        
        return Singleton.instance
    }
}
