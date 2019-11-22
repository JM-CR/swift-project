//
//  FilterViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit
import CoreData

class FiltersViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var categories: [String]!
    
    // MARK: Core Data
    
    var currentUser: User!
    
    
    // MARK: - Actions
    
    /**
     Returns to the generalVC.
     
     - Parameter sender: Button that triggered the action.
     */
    @IBAction func returnButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension FiltersViewController: UITableViewDataSource {
    
    /**
     Indicates the number of rows for a given section.
     
     - Parameter tableView: TableView object.
     - Parameter section: Section to query.
     - Returns: Total of rows for section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    /**
     Formats a cell in the tableView.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Current position of cell.
     - Returns: Cell ready to display.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get reusable cell
        let filterCell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterTableViewCell
        
        // Set up cell
        filterCell.categoryDescription.text = self.categories[indexPath.row]
        filterCell.categoryDescription.sizeToFit()
        
        // Check active filters
        let filterObjects = self.currentUser.filters as! Set<Filter>
        if (filterObjects.contains { $0.category == self.categories[indexPath.row] }) {
            filterCell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return filterCell
    }
    
}

extension FiltersViewController: UITableViewDelegate {

    /**
     Adds a checkmark when the row is selected.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Position of the selected cell.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let filterCell = tableView.cellForRow(at: indexPath) {
            filterCell.accessoryType = .checkmark
            
            // Add new filter
            let newFilter = Filter(context: self.currentUser.managedObjectContext!)
            newFilter.category = self.categories[indexPath.row]
            self.currentUser.addToFilters(newFilter)
        }
    }
    
    /**
     Removes the checkmark when the row is selected.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Position of the selected cell.
     */
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let filterCell = tableView.cellForRow(at: indexPath) {
            filterCell.accessoryType = .none
            
            // Remove filter
            let filterObjects = self.currentUser.filters as! Set<Filter>
            let filterToDelete = filterObjects.filter { $0.category == self.categories[indexPath.row] }.first!
            self.currentUser.removeFromFilters(filterToDelete)
        }
    }
    
}
