//
//  PosterTableViewCell.swift
//  Movs
//
//  Created by Adolfho Athyla on 08/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit

class PosterTableViewCell: UITableViewCell {

    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieVoteAverage: UILabel!
    @IBOutlet var moviePopularity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
