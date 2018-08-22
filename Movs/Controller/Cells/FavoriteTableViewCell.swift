//
//  FavoriteTableViewCell.swift
//  Movs
//
//  Created by Adolfho Athyla on 08/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieOverview: UILabel!
    @IBOutlet var movieYear: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
