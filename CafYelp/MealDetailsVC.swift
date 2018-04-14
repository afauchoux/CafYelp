//
//  MealDetailsVC.swift
//  CafYelp
//
//  Created by litmandev on 4/14/18.
//  Copyright © 2018 Brennan Linse. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MealDetailsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var LabelStack: UIStackView!
    @IBOutlet weak var TableReviews: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    
    
    // Properties
    var selectedMeal: String!
    var selectedLine: Line!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currMealID: String?
        
        switch self.selectedMeal.lowercased() {
        case "breakfast":
            currMealID = selectedLine.breakfastMealID
        case "lunch":
            currMealID = selectedLine.lunchMealID
        case "dinner":
            currMealID = selectedLine.dinnerMealID
        default:
            fatalError("Couldn't get the selected meal")
        }
        
        
        Database.database().reference().child("meals").child(currMealID!).observe(.value) { (snapshot) in
            if let mealData = snapshot.value as? [String : Any], let mealName = mealData["name"] as? String, let mealAvgRating = mealData["averageRating"] as? Double, let mealNumRatings = mealData["numberOfRatings"] as? Int {
                
                self.nameLabel.text = mealName
                self.averageRatingLabel.text = "Average: \(mealAvgRating)/5 stars"
                self.numberOfReviewsLabel.text = "[\(mealNumRatings) reviews]"
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
}












