//
//  AddReviewVC.swift
//  CafYelp
//
//  Created by Brennan Linse on 4/14/18.
//  Copyright © 2018 Brennan Linse. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddReviewVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private let imagePicker = UIImagePickerController()
    private var didSelectAnImage = false
    
    
    // Properties
    var mealToReviewID: String!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        
        let imageSourceAlert = UIAlertController(title: "Where is your image?", message: nil, preferredStyle: .actionSheet)
        
        imageSourceAlert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(self.imagePicker, animated: true)
        }))
        
        imageSourceAlert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.imagePicker, animated: true)
        }))
        
        self.present(imageSourceAlert, animated: true)
        
        
        
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = pickedImage
            self.didSelectAnImage = true
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
    
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        var updates = [String : Any]()
        let newReviewID = Database.database().reference().child("reviews").childByAutoId().key
        var newReviewData = [String : Any]()
        
        newReviewData["starRating"] = Int(ratingSlider.value)
        
        let description = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !description.isEmpty {
            newReviewData["description"] = description
        }
        
        if let reviewTitle = titleTextField.text, !reviewTitle.isEmpty {
            newReviewData["title"] = reviewTitle
        }
        
        newReviewData["mealID"] = mealToReviewID
        
        if didSelectAnImage, let imageData = UIImageJPEGRepresentation(imageView.image!, 0.2) {
            // Upload the review image to Storage.
            let uniqueID = UUID().uuidString
            Storage.storage().reference().child("review-images").child(uniqueID).putData(imageData, metadata: nil) { (metadata, error) in
                
                guard error == nil, metadata != nil, let downloadURL = metadata!.downloadURL()?.absoluteString else {
                    // There was an issue with Storage.
                    print("Couldn't upload the image to storage.")
                    return
                }
                
                newReviewData["imageURL"] = downloadURL
                
                updates["/mealReviews/\(self.mealToReviewID ?? "mealIDSteak")/\(newReviewID)"] = true
                updates["/reviews/\(newReviewID)"] = newReviewData
                
                Database.database().reference().child("meals").child(self.mealToReviewID).runTransactionBlock({ (currentSnapshot) -> TransactionResult in
                    if var currentMealData = currentSnapshot.value as? [String : Any], let currNumRatings = currentMealData["numberOfRatings"] as? Double, let currTotalRating = currentMealData["totalRating"] as? Double {
                        print("Running the DB transaction")
                        
                        let newNumRatings = currNumRatings + 1
                        let newTotalRating = currTotalRating +
                            Double(self.ratingSlider.value)
                        let newAverageRating = newTotalRating / newNumRatings
                        
                        currentMealData["numberOfRatings"] = newNumRatings
                        currentMealData["totalRating"] = newTotalRating
                        currentMealData["averageRating"] = newAverageRating
                        
                        print("here1")
                        currentSnapshot.value = currentMealData
                        print("here2")
                        return TransactionResult.success(withValue: currentSnapshot)
                        
                    }
                    return TransactionResult.success(withValue: currentSnapshot)
                }, andCompletionBlock: { (error, success, snapshot) in
                    guard error == nil else {
                        print("Error: DB transaction failed")
                        return
                    }
                    
                    Database.database().reference().updateChildValues(updates, withCompletionBlock: { (error, ref) in
                        guard error == nil else {
                            print("DB error: \(error!.localizedDescription)")
                            return
                        }
                        
                        self.dismiss(animated: true)
                    })
                })
            }
        } else {
            // Didn't select a review image.
            print("Didn't select an image")
            updates["/mealReviews/\("mealIDSteak")/\(newReviewID)"] = true
            updates["/reviews/\(newReviewID)"] = newReviewData
            print("Updates to push to the database: \(updates)")
            Database.database().reference().child("meals").child(self.mealToReviewID).runTransactionBlock({ (currentSnapshot) -> TransactionResult in
                if var currentMealData = currentSnapshot.value as? [String : Any], let currNumRatings = currentMealData["numberOfRatings"] as? Double, let currTotalRating = currentMealData["totalRating"] as? Double {
                    print("Running the DB transaction")
                    
                    let newNumRatings = currNumRatings + 1
                    let newTotalRating = currTotalRating +
                        Double(self.ratingSlider.value)
                    let newAverageRating = newTotalRating / newNumRatings
                    
                    currentMealData["numberOfRatings"] = newNumRatings
                    currentMealData["totalRating"] = newTotalRating
                    currentMealData["averageRating"] = newAverageRating
                    
                    currentSnapshot.value = currentMealData
                    
                    return TransactionResult.success(withValue: currentSnapshot)
                    
                }
                return TransactionResult.success(withValue: currentSnapshot)
            }, andCompletionBlock: { (error, success, snapshot) in
                guard error == nil, success == true else {
                    print("Error: DB transaction failed")
                    return
                }
                
                Database.database().reference().updateChildValues(updates, withCompletionBlock: { (error, ref) in
                    guard error == nil else {
                        print("DB error: \(error!.localizedDescription)")
                        return
                    }
                    
                    self.dismiss(animated: true)
                })
            })
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let discreteValue = round(sender.value)
        sender.setValue(discreteValue, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
