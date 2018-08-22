//
//  GenreFilterViewController.swift
//  Movs
//
//  Created by Adolfho Athyla on 09/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit

class GenreFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var genres = [Genre]()
    
    var completion: ((_ genre: Genre) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillData()
        
        self.title = "Genre"
        
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - fill table
    private func fillData() {
        genres = Genre.getAllGenres()!
    }
    
    //MARK: - table view datasource and delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YEAR_FILTER_IDENTIFIER", for: indexPath)
        
        cell.textLabel?.text = "\(genres[indexPath.row].name ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let completion = completion {
            completion(genres[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
