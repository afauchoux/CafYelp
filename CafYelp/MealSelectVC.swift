//
//  MealSelectVC.swift
//  CafYelp
//
//  Created by Brennan Linse on 4/14/18.
//  Copyright © 2018 Brennan Linse. All rights reserved.
//

import UIKit

class MealSelectVC: UIViewController {

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func mealButtonTapped(_ sender: UIButton) {
        let mealSelected = sender.titleLabel!.text!
        performSegue(withIdentifier: "toLineSelectTVC", sender: mealSelected)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLineSelectTVC", let lineSelectScreen = segue.destination as? LineSelectTVC {
            if let selectedMeal = sender as? String {
                lineSelectScreen.navigationItem.title = "Today's \(selectedMeal.capitalized) Options"
                lineSelectScreen.selectedMeal = selectedMeal
            }
            
        }
    }
    
    
    
    
    
}

