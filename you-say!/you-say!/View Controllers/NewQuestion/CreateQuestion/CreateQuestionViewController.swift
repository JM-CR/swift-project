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
    
    // MARK: - Outlet
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    // MARK: Properties
    
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
    
    /**
     Creates a new question when all fields are full.
     
     - Parameter sender: Button that triggered the action.
     */
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        do {
            // Validate input
            try validateQuestion()
            
        } catch NewQuestionError.InvalidCategory(let description) {
            showAlert(title: description, message: "")
        } catch {
            
        }
    }
    
    
    // MARK: - Validation
    
    /**
     Validates if the question is ready to process.
     
     - Throws: NewQuestionError.InvalidCategory
     */
    private func validateQuestion() throws {
        guard let _ = self.selectedCategory else {
            throw NewQuestionError.InvalidCategory(description: "No has elegido una categoría.")
        }
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
        self.categoryLabel.text = value
    }
    
}
