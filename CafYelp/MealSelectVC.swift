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
        let mealSelected = sender.titleLabel!.text
        performSegue(withIdentifier: "toLineSelectVC", sender: mealSelected)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLineSelectVC"
        {
            if let nextScreen = segue.destination as? LineSelectVC
            {
                // Set something on the next screen
            }
        }
    }
    
    
    
    
    
}

