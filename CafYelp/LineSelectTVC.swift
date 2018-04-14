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
    var selectedMeal: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the names of the line options and populate the table view.
        
        Database.database().reference().child("lines").observe(.value) { (snap) in
            if let linesDict = snap.value as? [String : Any] {
                
                print(linesDict)
                
                let lineIDs = linesDict.keys
                for lineID in lineIDs
                {
                    if let currLineData = linesDict[lineID] as? [String : Any], let lineName = currLineData["name"] as? String, let breakfastMealID = currLineData["breakfastMeal"] as? String, let lunchMealID = currLineData["lunchMeal"] as? String, let dinnerMealID = currLineData["dinnerMeal"] as? String {
                        let aLine = Line(name: lineName, lineID: lineID, breakfastMealID: breakfastMealID, lunchMealID: lunchMealID, dinnerMealID: dinnerMealID)
                        self.lines.append(aLine)
                    }
                }
                self.lines.sort(by: { (lineA, lineB) -> Bool in
                    return lineA.name < lineB.name
                })
                self.lines.swapAt(1, 0)
                self.lines.swapAt(1, 3)
                self.tableView.reloadData()
            }
        }
        
        
        
        
        
        
        
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lines.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.lines[indexPath.row].name
        
        return cell
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedLine = self.lines[indexPath.row]
        performSegue(withIdentifier: "toMealDetailsVC", sender: (self.selectedMeal, selectedLine))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMealDetailsVC", let selectedOptions = sender as? (String, Line), let nextScreen = segue.destination as? MealDetailsVC {
            nextScreen.selectedMeal = selectedOptions.0
            nextScreen.selectedLine = selectedOptions.1
        }
    }
    
    
    
    
    
    
    
    
    
    
    

}
