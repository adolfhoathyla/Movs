//
//  Movie.swift
//  Movs
//
//  Created by Adolfho Athyla on 05/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit
import EVReflection
import CoreData

class Movie: EVObject {
    var id: NSNumber?
    var title: String?
    var vote_average: NSNumber?
    var popularity: NSNumber?
    var poster_path: String?
    var genre_ids = [NSNumber]()
    var overview: String?
    var release_date: String?
    
    var release_dateCD: Date?
    var poster: UIImage?
    
    var movieMO: NSManagedObject?
    
    required init() {}
    
    //MARK: - Operations
    func isFavorite() -> Bool {
        let favorites = Movie.getAllFavoriteMovies()
        let containInFavorites = favorites?.contains(where: { (movie) -> Bool in
            movie.id == self.id
        })
        return containInFavorites ?? false
    }
    
    func getGenres() -> [Genre]? {
        var genres = [Genre]()
        let allGenresOpt = Genre.getAllGenres()
        guard let allGenres = allGenresOpt else { return nil }
        for genreId in genre_ids {
            let genreT = allGenres.filter({ (genre) -> Bool in
                genre.id == genreId
            })
            genres.append(contentsOf: genreT)
        }
        return genres
    }
    
    func getCompletePosterUri(size: Int) -> String {
        return "https://image.tmdb.org/t/p/w\(size)" + (poster_path ?? "") + "?api_key=\(String(describing: MovieDBAPI.apiKey ?? ""))" 
    }
    
    //MARK: - CoreData
    static func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    }
    
    init(mo: NSManagedObject) {
        super.init()
        
        id = mo.value(forKey: "id") as? NSNumber
        title = mo.value(forKey: "title") as? String
        vote_average = mo.value(forKey: "vote_average") as? NSNumber
        popularity = mo.value(forKey: "popularity") as? NSNumber
        poster_path = mo.value(forKey: "poster_path") as? String
        overview = mo.value(forKey: "overview") as? String
        release_dateCD = mo.value(forKey: "release_date") as? Date
        genre_ids = mo.value(forKey: "genre_ids") as! [NSNumber]
        poster = UIImage(data: (mo.value(forKey: "poster") as! Data))
        
        movieMO = mo
    }
    
    func save() {
        let context = Movie.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "MovieMO", in: context)
        
        if let _ = self.movieMO {} else {
            self.movieMO = NSManagedObject(entity: entity!, insertInto: context)
        }
        
        if let _ = self.release_date {
            self.release_dateCD = Date.dateSourcedInServer(dateString: release_date!)
        }
        
        movieMO?.setValue(id, forKey: "id")
        movieMO?.setValue(title, forKey: "title")
        movieMO?.setValue(vote_average, forKey: "vote_average")
        movieMO?.setValue(popularity, forKey: "popularity")
        movieMO?.setValue(poster_path, forKey: "poster_path")
        movieMO?.setValue(overview, forKey: "overview")
        movieMO?.setValue(release_dateCD, forKey: "release_date")
        movieMO?.setValue(genre_ids, forKey: "genre_ids")
        movieMO?.setValue(poster?.sd_imageData(), forKey: "poster")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Erro ao salvar objeto movie: \(error)")
        }
    }
    
    static func getAllFavoriteMovies() -> [Movie]? {
        let context = Movie.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieMO")
        
        var movies = [Movie]()
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let results = results as? [NSManagedObject] {
                for result in results {
                    movies.append(Movie(mo: result))
                }
            }
            return movies
        } catch let error as NSError {
            print("Erro ao recuperar objetos Movies: \(error)")
        }
        return nil
    }
    
    func delete() {
        let context = Movie.getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieMO")
        fetchRequest.predicate = NSPredicate.init(format: "id==\(self.id ?? 0)")
        
        do {
            let objects = try context.fetch(fetchRequest)
            context.delete(objects.first! as! NSManagedObject)
            try context.save()
        } catch {
            print("Erro ao remover objeto Movie")
        }
    }
}
