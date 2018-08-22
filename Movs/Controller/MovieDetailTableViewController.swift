//
//  MovieDetailTableViewController.swift
//  Movs
//
//  Created by Adolfho Athyla on 08/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit

class MovieDetailTableViewController: UITableViewController {

    var movie: Movie?
    
    var favoriteButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        updateFavoriteButton()
        
        favoriteButton.addTarget(self, action: #selector(MovieDetailTableViewController.actionFavorite), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Operations
    @objc func actionFavorite() {
        movie!.isFavorite() ? movie?.delete() : movie?.save()
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        if movie!.isFavorite() {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorites-full-black"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorites"), for: .normal)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "POSTER_IDENTIFIER", for: indexPath) as? PosterTableViewCell
            cell?.moviePoster.image = movie?.poster
            cell?.moviePopularity.text = String(format: "%.3f", movie?.popularity?.doubleValue ?? 0)
            cell?.movieVoteAverage.text = String(format: "%.2f", movie?.vote_average?.doubleValue ?? 0)
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "INFO_IDENTIFIER", for: indexPath) as? InfoTableViewCell
            cell?.movieInfo.text = movie?.title
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GENRES_IDENTIFIER", for: indexPath)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OVERVIEW_IDENTIFIER", for: indexPath) as? OverviewTableViewCell
            cell?.movieOverview.text = movie?.overview
            return cell!
        default: break
            
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 238.0
        }
        if indexPath.section == 2 {
            return 76.0
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Release date \(movie?.release_date ?? (movie?.release_dateCD?.stringDate() ?? "-"))"
        case 1:
            return "title"
        case 2:
            return "genres"
        case 3:
            return "overview"
        default: break
        }
        return ""
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MovieDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie?.getGenres()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GENRE_IDENTIFIER", for: indexPath) as? GenreCollectionViewCell
        cell?.movieGenreLabel.text = movie!.getGenres()![indexPath.row].name
        return cell!
    }
    
}


extension MovieDetailTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: (width/2.5)-15, height: (width/7))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    }
}

