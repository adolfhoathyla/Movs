//
//  Genre.swift
//  Movs
//
//  Created by Adolfho Athyla on 04/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit
import EVReflection
import CoreData

class Genre: EVObject {
    var id: NSNumber?
    var name: String?
    
    var genreMO: NSManagedObject?
    
    required init() {}
    
    //MARK: - Operations
    func getFavoritesMovies() -> [Movie]? {
        var movies = [Movie]()
        
        let allFavoritesMoviesOpt = Movie.getAllFavoriteMovies()
        guard let allFavoriteMovies = allFavoritesMoviesOpt else { return nil }
        
        movies = allFavoriteMovies.filter { (movie) -> Bool in
            movie.genre_ids.contains(id!)
        }
        
        return movies
    }
    
    //MARK: - CoreData
    static func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    }
    
    init(mo: NSManagedObject) {
        super.init()
        
        id = mo.value(forKey: "id") as? NSNumber
        name = mo.value(forKey: "name") as? String
        
        genreMO = mo
    }
    
    func save() {
        let context = Genre.getContext()
        
        if let _ = genreMO {} else {
            self.genreMO = NSEntityDescription.insertNewObject(forEntityName: "GenreMO", into: context)
        }
        
        genreMO?.setValue(id, forKey: "id")
        genreMO?.setValue(name, forKey: "name")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Erro ao salvar Genre: \(error)")
        }
    }
    
    static func getAllGenres() -> [Genre]? {
        let context = Movie.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GenreMO")
        
        var genres = [Genre]()
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let results = results as? [NSManagedObject] {
                for result in results {
                    genres.append(Genre(mo: result))
                }
            }
            return genres
        } catch let error as NSError {
            print("Erro ao recuperar Genres \(error)")
        }
        return nil
    }
}
