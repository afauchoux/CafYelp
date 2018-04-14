//
//  MealDetailsVC.swift
//  CafYelp
//
//  Created by litmandev on 4/14/18.
//  Copyright © 2018 Brennan Linse. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

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
    var selectedMealID: String!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the add button and add it to the UI.
        
        let addReviewButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(handleAddButtonTapped))
        
        self.navigationItem.setRightBarButton(addReviewButton, animated: true)
        
        
        
        
        
        // Grab meal data from the database and display it.
        
        switch self.selectedMeal.lowercased() {
        case "breakfast":
            self.selectedMealID = selectedLine.breakfastMealID
        case "lunch":
            self.selectedMealID = selectedLine.lunchMealID
        case "dinner":
            self.selectedMealID = selectedLine.dinnerMealID
        default:
            fatalError("Couldn't get the selected meal")
        }
        
        Database.database().reference().child("meals").child(self.selectedMealID!).observe(.value) { (snapshot) in
            if let mealData = snapshot.value as? [String : Any], let mealName = mealData["name"] as? String, let mealAvgRating = mealData["averageRating"] as? Double, let mealNumRatings = mealData["numberOfRatings"] as? Int {
                
                if let imageURL = mealData["imageURL"] as? String {
                    print("Got image URL")
                    Storage.storage().reference(forURL: imageURL).getData(maxSize: 2 * 1024 * 1024, completion: { (imageData, error) in
                        if error != nil {
                            print("Couldn't get the image from storage: \(error!.localizedDescription)")
                        } else {
                            // Successful download...
                            if let downloadedImage = UIImage(data: imageData!) {
                                self.FoodImage.image = downloadedImage
                            }
                        }
                    })
                }
                
                
                
                self.nameLabel.text = mealName
                let mealAvgRounded = Double(Int(mealAvgRating * 100)) / 100
                self.averageRatingLabel.text = "Average: \(mealAvgRounded)/5 stars"
                self.numberOfReviewsLabel.text = "[\(mealNumRatings) reviews]"
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    @objc func handleAddButtonTapped() {
        performSegue(withIdentifier: "toAddReviewVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddReviewVC", let addReviewVC = (segue.destination as? UINavigationController)?.topViewController as? AddReviewVC {
            addReviewVC.mealToReviewID = self.selectedMealID
        }
    }
    
    
    
    
    
    
    
    
}












