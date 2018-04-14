//
//  ReviewsTVC.swift
//  CafYelp
//
//  Created by Brennan Linse on 4/14/18.
//  Copyright © 2018 Brennan Linse. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ReviewsTVC: UITableViewController {
    
    
    var currMealID: String!
    var reviews = [Review]()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("mealReviews").child(currMealID).observe(.value) { (snapshot) in
            if let reviewIDs = (snapshot.value as? [String : Any])?.keys {
                var reviewsToDownload = reviewIDs.count
                print(reviewIDs)
                for reviewID in reviewIDs {
                    Database.database().reference().child("reviews").child(reviewID).observeSingleEvent(of: .value, with: { (snapshot) in
                        reviewsToDownload -= 1
                        print("Downloaded a review")
                        if let reviewData = snapshot.value as? [String : Any], let reviewRating = reviewData["starRating"] as? Int {
                            let reviewTitle = reviewData["title"] as? String
                            let reviewDescription = reviewData["description"] as? String
                            
                            let currReview = Review(description: reviewDescription, mealID: self.currMealID, starRating: reviewRating, title: reviewTitle)
                            
                            self.reviews.append(currReview)
                            if reviewsToDownload == 0 {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
        
        
        
        
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell {
            let currReview = self.reviews[indexPath.row]
            cell.configureCell(review: currReview)
            
            return cell
        }
        return UITableViewCell()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
