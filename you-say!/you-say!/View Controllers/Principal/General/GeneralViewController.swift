//
//  MainViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController {
    
    // MARK: - Navigation

    /**
     Prepares the controller to perform the segue.
     
     - Parameter segue: Segue's type.
     - Parameter sender: View controller that presents.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "filterSegue":
            // Get parent controller
            guard let navigationVC = self.tabBarController as? NavigationViewController else { return }
            
            // Pass data to destination
            let filtersVC = segue.destination as! FiltersViewController
            filtersVC.currentUser = navigationVC.currentUser
            filtersVC.categories = navigationVC.categories
            
        case "myQuestionsSegue":
            // Get parent controller
            guard let navigationVC = self.tabBarController as? NavigationViewController else { return }
            
            // Pass data to destination
            let myQuestionsVC = segue.destination as! MyQuestionsViewController
            myQuestionsVC.currentUser = navigationVC.currentUser
            
        default:
            return
        }
    }

}

// MARK: - TableView Data Source

extension GeneralViewController: UITableViewDataSource {
    
    /**
     Indicates the number of rows for a given section.
     
     - Parameter tableView: TableView object.
     - Parameter section: Section to query.
     - Returns: Total of rows for section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /**
     Formats a cell in the tableView.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Current position of cell.
     - Returns: Cell ready to display.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get reusable cell
        let generalCell = tableView.dequeueReusableCell(withIdentifier: "generalCell", for: indexPath) as! GeneralTableViewCell
        
        // Set up cell
        
        return generalCell
    }
    
}

// MARK: - TableView Delegate

extension GeneralViewController: UITableViewDelegate {
    
    
}
