//
//  CreateViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/22/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit
import CoreLocation

class CreateQuestionViewController: UIViewController {
    
    // MARK: - Properties
    
    var categories: [String]!
    var selectedCategory: String?
    
    // MARK: Core Data
    
    var currentUser: User!
    
    // MARK: Core Location
    
    var selectedCoordinate: CLLocationCoordinate2D!
    
    
    // MARK: - Actions
    
    /**
     Returns to locationVC.
     
     - Parameter sender: Button that triggered the action.
     */
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    /**
     Prepares the controller to perform the segue.
     
     - Parameter segue: Segue's type.
     - Parameter sender: View controller that presents.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "categorySegue":
            // Pass data to destination
            let categoriesVC = segue.destination as! CategoriesViewController
            categoriesVC.categories = self.categories
            categoriesVC.selectedCategory = self.selectedCategory
            categoriesVC.delegate = self
            
        default:
            return
        }
    }

}

// MARK: - Categories Delegate

extension CreateQuestionViewController: CategoriesDelegate {
    
    /**
     Updates the current option for the question.
     
     - Parameter value: Selected category.
     */
    func optionSelected(value: String) {
        self.selectedCategory = value
    }
    
}
