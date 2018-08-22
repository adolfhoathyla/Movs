//
//  FavoritesViewController.swift
//  Movs
//
//  Created by Adolfho Athyla on 08/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var genres = [Genre]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateMovies()
        
        tableView.reloadData()
    }
    
    //MARK: - Operations
    func updateMovies() {
        genres = Genre.getAllGenres()!.filter({ (genre) -> Bool in
            genre.getFavoritesMovies()!.count > 0
        })
    }
    
    //MARK: - TableView datasource and delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres[section].getFavoritesMovies()!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAVORITE_TABLE_IDENTIFIER", for: indexPath) as? FavoriteTableViewCell
        
        guard let favorites = genres[indexPath.section].getFavoritesMovies() else { return UITableViewCell() }
        let movie = favorites[indexPath.row]
        cell?.movieTitle.text = movie.title
        cell?.movieYear.text = "\(movie.release_dateCD?.year() ?? 2000)"
        cell?.movieOverview.text = movie.overview
        cell?.moviePoster.image = movie.poster
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GO_TO_MOVIE_DETAIL", sender: indexPath)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return genres[section].name
    }
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Unfavorite"
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            genres[indexPath.section].getFavoritesMovies()![indexPath.row].delete()
            updateMovies()
            tableView.reloadData()
        }
     }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        guard let indexPath = sender as? IndexPath else{ return }
        switch identifier {
        case "GO_TO_MOVIE_DETAIL":
            let detailVC = segue.destination as? MovieDetailTableViewController
            detailVC?.movie = genres[indexPath.section].getFavoritesMovies()?[indexPath.row]
        default:
            break
        }
    }
    

}
