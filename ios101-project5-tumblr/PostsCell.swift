//
//  PostsCell.swift
//  ios101-project5-tumblr
//
//  Created by Juan Matias on 3/24/24.
//

import UIKit

class PostsCell: UITableViewCell {

    @IBOutlet weak var postsImageView: UIImageView!
    
    @IBOutlet weak var postsLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
