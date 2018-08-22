//
//  MoviesViewController.swift
//  Movs
//
//  Created by Adolfho Athyla on 04/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit
import SDWebImage

class MoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var popular = Popular()
    
    var filteredMovies = [Movie]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configActivityIndicator()

        MovieDBAPI.loadPopularMovies { (popular) in
            guard let _ = popular else { return }
            self.popular = popular!
            self.collectionView.reloadData()
            self.spinner.stopAnimating()
            
            //load genres (if needed)
            if let genres = Genre.getAllGenres() {
                if genres.isEmpty {
                    MovieDBAPI.loadGenres { (genres) in
                        if let genres = genres {
                            for genre in genres.genres {
                                genre.save()
                            }
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    //MARK: - Actions
    @IBAction func favoriteAction(_ sender: UIButton) {
        let hitPoint = sender.convert(CGPoint.zero, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: hitPoint) {
            let movie = shouldShowSearchResults ? filteredMovies[indexPath.row] : popular.results[indexPath.row]
            if movie.isFavorite() {
                movie.delete()
            } else {
                movie.save()
            }
            self.collectionView.reloadData()
        }
    }
    
    private func configActivityIndicator() {
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
    }
    
    
    //MARK: - Search bar

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            shouldShowSearchResults = true
            filteredMovies = popular.results.filter({ (movie) -> Bool in
                movie.title?.range(of: searchText, options: .caseInsensitive) != nil
            })
            collectionView.reloadData()
        } else {
            shouldShowSearchResults = false
            collectionView.reloadData()
        }
    }
 
    //MARK: - Requests
    private func loadMorePopularMovies() {
        self.spinner.startAnimating()
        self.page = self.page + 1
        MovieDBAPI.loadPopularMovies(page: page) { (popular) in
            guard let popular = popular else { return }
            self.popular.results.append(contentsOf: popular.results)
            self.popular.page = popular.page
            self.collectionView.reloadData()
            self.spinner.stopAnimating()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        guard let indexPath = sender as? IndexPath else { return }
        switch identifier {
        case "GO_TO_MOVIE_DETAIL":
            let detailVC = segue.destination as? MovieDetailTableViewController
            detailVC?.movie = shouldShowSearchResults ? filteredMovies[indexPath.row] : popular.results[indexPath.row]
        default:
            break
        }
    }
    
    //MARK: - CollectionView datasource and delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shouldShowSearchResults ? filteredMovies.count : popular.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MOVIE_COLLECTION_IDENTIFIER", for: indexPath) as? MovieCollectionViewCell
        
        let movie = shouldShowSearchResults ? filteredMovies[indexPath.row] : popular.results[indexPath.row]
        
        movieCell?.movieName.text = movie.title
        
        //is favorite?
        if movie.isFavorite() {
            movieCell?.movieFavoriteButton.setImage(#imageLiteral(resourceName: "favorites-full-alt"), for: .normal)
        } else {
            movieCell?.movieFavoriteButton.setImage(#imageLiteral(resourceName: "favorites-alt"), for: .normal)
        }
        
        movieCell?.moviePoster.sd_setImage(with: URL(string: movie.getCompletePosterUri(size: 500)), completed: { (image, error, type, url) in
            if let _ = movie.poster {} else {
                movie.poster = image
            }
        })
        
        //load poster
        if let poster = movie.poster {
            movieCell?.moviePoster.image = poster
        } else {
            movieCell?.spinner.startAnimating()
        }
        
        return movieCell!
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !shouldShowSearchResults {
            let moviesCount = popular.results.count
            if indexPath.row == moviesCount-1 {
                self.loadMorePopularMovies()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GO_TO_MOVIE_DETAIL", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SEARCH_HEADER_IDENTIFIER", for: indexPath)

            return header
        default:
            return UICollectionReusableView()
        }
    }
}


extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: (width/2)-20, height: (width/1.5))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    }
}
