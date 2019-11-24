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
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceStackView: UIStackView!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceSwitch: UISwitch!
    
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
    @IBAction func publishButtonPressed(_ sender: UIBarButtonItem) {
        do {
            // Validate input
            try validateQuestion()
            
        } catch NewQuestionError.InvalidCategory(let description) {
            showAlert(title: description, message: "")
        } catch {
            
        }
    }
    
    /**
     Activates distance if the user turn on the option.
     
     - Parameter sender: Switch that triggered the action.
     */
    @IBAction func activateDistance(_ sender: UISwitch) {
        if sender.isOn {
            self.distanceStackView.isHidden = false
        } else {
            self.distanceStackView.isHidden = true
        }
    }
    
    /**
     Updates the distance label to show current status.
     
     - Parameter sender: Slider that was triggered.
     */
    @IBAction func distanceChanged(_ sender: UISlider) {
        // Maximum step size
        let step: Float = 5
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        // Update value in label
        if sender.value.truncatingRemainder(dividingBy: 5) == 0 {
            self.distanceLabel.text = String(format: "%.0f km", sender.value)
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
