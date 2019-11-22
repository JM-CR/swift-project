//
//  CategoriesViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/22/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var categories: [String]!
    var selectedCategory: String?
    
    var delegate: CategoriesDelegate?
    
    
    // MARK: - Actions
    
    /**
     Returns to createVC.
     
     - Parameter sender: Button that triggered the action.
     */
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Data Source

extension CategoriesViewController: UITableViewDataSource {
    
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
        let optionCell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as! OptionTableViewCell
        
        // Set up cell
        optionCell.categoryDescription.text = self.categories[indexPath.row]
        optionCell.categoryDescription.sizeToFit()
        
        // Check active option
        if self.categories[indexPath.row] == self.selectedCategory {
            optionCell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return optionCell
    }
}

// MARK: - TableView Delegate

extension CategoriesViewController: UITableViewDelegate {
    
    /**
     Comunicates to CreateQuestionVC the selected category.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Selected cell.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Call delegate
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.optionSelected(value: self.categories[indexPath.row])
        
        // Exit
        dismiss(animated: true, completion: nil)
    }
    
}
