//
//  ReviewCell.swift
//  CafYelp
//
//  Created by Brennan Linse on 4/14/18.
//  Copyright © 2018 Brennan Linse. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var thumbsImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(review: Review) {
        titleLabel.text = review.title ?? "[Untitled]"
        ratingLabel.text = "\(review.starRating) / 5 stars"
        if review.starRating >= 3 {
            thumbsImageView.image = UIImage(named: "thumbs-up")
        } else {
            thumbsImageView.image = UIImage(named: "thumbs-down")
        }
        
        
        
        
    }
    
    
    

}
