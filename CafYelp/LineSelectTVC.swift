//
//  LineSelectTVC.swift
//  CafYelp
//
//  Created by Brennan Linse on 4/14/18.
//  Copyright © 2018 Brennan Linse. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LineSelectTVC: UITableViewController {
    
    var lines: [Line] = [Line]()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the names of the line options and populate the table view.
        
        Database.database().reference().child("lines").observe(DataEventType.value) { (snap) in
            
            if let linesDict = snap.value as? [String : Any] {
                
                let lineIDs = linesDict.keys
                for lineID in lineIDs
                {
                    if let currLine = linesDict[lineID] as? [String : Any], let {
                        
                        
                        
                        
                    }
                }
                
                
                
            }
            
            
            
        }
        
        
        
        
        
        
        
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    
    
    enum Direction
    {
        case north
        case south
        case east
        case west
    }
    
    
    

}
