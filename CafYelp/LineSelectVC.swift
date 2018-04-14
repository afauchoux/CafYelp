//
//  LineSelectVC.swift
//  CafYelp
//
//  Created by Brennan Linse on 4/14/18.
//  Copyright © 2018 Brennan Linse. All rights reserved.
//

import UIKit

class LineSelectVC: UIViewController {
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This function happens when this screen first loads.
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddTapped))
        
        self.navigationItem.setRightBarButtonItems([addButton], animated: true)
        
        
    }
    
    
    
    
    
    @objc func handleAddTapped() {
        print("Add was tapped")
    }
    
    
    
    
    
    
    
}
