//
//  FavoritesFilterViewController.swift
//  Movs
//
//  Created by Adolfho Athyla on 09/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit

class FavoritesFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var removeFilterButton: UIBarButtonItem!
    
    var favorites = [Movie]()
    
    var filteredFavorites = [Movie]()
    
    var shouldShowSearchResults = false
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeFilterButton.isEnabled = false
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
        favorites = Movie.getAllFavoriteMovies()!
    }
    
    @IBAction func filterAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "GO_TO_MOVIE_FILTER_VIEW", sender: nil)
    }
    
    @IBAction func removeFilterAction(_ sender: UIBarButtonItem) {
        shouldShowSearchResults = false
        tableView.reloadData()
        removeFilterButton.isEnabled = false
    }
    
    func filter(year: Int) -> [Movie] {
        return favorites.filter({ (movie) -> Bool in
            movie.release_dateCD?.year() == year
        })
    }
    
    //MARK: - Search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            shouldShowSearchResults = true
            filteredFavorites = favorites.filter({ (movie) -> Bool in
                movie.title?.range(of: searchText, options: .caseInsensitive) != nil
            })
            tableView.reloadData()
        } else {
            shouldShowSearchResults = false
            tableView.reloadData()
        }
    }
    
    //MARK: - TableView datasource and delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowSearchResults ? filteredFavorites.count : favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAVORITE_TABLE_IDENTIFIER", for: indexPath) as? FavoriteTableViewCell
        
        let movie = shouldShowSearchResults ? filteredFavorites[indexPath.row] : favorites[indexPath.row]
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
        return "favorites"
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
            shouldShowSearchResults ? filteredFavorites[indexPath.row].delete() : favorites[indexPath.row].delete()
            if shouldShowSearchResults {
                filteredFavorites.remove(at: indexPath.row)
            }
            updateMovies()
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "GO_TO_MOVIE_DETAIL":
            guard let indexPath = sender as? IndexPath else{ return }
            let detailVC = segue.destination as? MovieDetailTableViewController
            detailVC?.movie = shouldShowSearchResults ? filteredFavorites[indexPath.row] : favorites[indexPath.row]
        case "GO_TO_MOVIE_FILTER_VIEW":
            let filterVC = segue.destination as? MovieFilterViewController
            self.removeFilterButton.isEnabled = true
            filterVC?.completion = { (filter) in
                self.shouldShowSearchResults = true
                if let year = filter as? Int {
                    self.filteredFavorites = self.filter(year: year)
                } else {
                    if let genre = filter as? Genre {
                        self.filteredFavorites = genre.getFavoritesMovies()!
                    }
                }
                self.tableView.reloadData()
            }
        default:
            break
        }
    }
    
    
}

