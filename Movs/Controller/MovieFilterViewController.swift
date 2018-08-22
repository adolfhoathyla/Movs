//
//  MovieFilterViewController.swift
//  Movs
//
//  Created by Adolfho Athyla on 09/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit

class MovieFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var year: Int?
    
    var genre: Genre?
    
    var completion: ((_ filter: Any) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Filter"
        
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func actionApply(_ sender: UIButton) {
        if let completion = completion {
            guard let year = year else {
                if let _ = genre {
                    completion(genre!)
                    navigationController?.popViewController(animated: true)
                }
                return
            }
            completion(year)
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - table view datasource and delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FILTER_TYPE_IDENTIFIER", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Date"
            if let _ = year {
                cell.detailTextLabel?.text = "\(year ?? 0)"
            } else {
                cell.detailTextLabel?.text = ""
            }
            if let _ = genre {
                cell.isUserInteractionEnabled = false
            } else {
                cell.isUserInteractionEnabled = true
            }
        case 1:
            cell.textLabel?.text = "Genre"
            if let _ = genre {
                cell.detailTextLabel?.text = genre?.name
            } else {
                cell.detailTextLabel?.text = ""
            }
            if let _ = year {
                cell.isUserInteractionEnabled = false
            } else {
                cell.isUserInteractionEnabled = true
            }
        default:
            break
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "GO_TO_FILTER_VIEW", sender: nil)
        case 1:
            performSegue(withIdentifier: "GO_TO_GENRE_FILTER_VIEW", sender: nil)
        default:
            break
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "GO_TO_FILTER_VIEW":
            let filterVC = segue.destination as? FilterViewController
            filterVC?.completion = { (year) in
                self.year = year
                self.tableView.reloadData()
            }
        case "GO_TO_GENRE_FILTER_VIEW":
            let genreFilter = segue.destination as? GenreFilterViewController
            genreFilter?.completion = { (genre) in
                self.genre = genre
                self.tableView.reloadData()
            }
        default:
            break
        }
    }
    

}
