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
    
    @IBOutlet weak var labelCategory: UILabel!
    
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var stackViewDistance: UIStackView!
    @IBOutlet weak var sliderDistance: UISlider!
    @IBOutlet weak var switchDistance: UISwitch!
    
    @IBOutlet weak var textFieldQuestion: UITextField!
    
    // MARK: Properties
    
    var categories: [String]!
    var selectedCategory: String?
    
    // MARK: Core Data
    
    var currentUser: User!
    
    // MARK: Core Location
    
    var selectedCoordinate: CLLocationCoordinate2D!
    
    
    // MARK: - View Life Cycle
    
    /**
     Initial setup for the controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial setup
        setupDelegates()
        setupGestures()
    }
    
    // MARK: Setup
    
    /**
     Sets the delegates for the view controller.
     */
    private func setupDelegates() {
        self.textFieldQuestion.delegate = self
    }
    
    /**
     Sets the initial gestures for the view controller.
     */
    private func setupGestures() {
        // Remove keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: Gestures
    
    /**
     Hides the keyboard when the user taps on the screen.
     */
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    
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
            try validateQuestion()
            createQuestion()
            
        } catch NewQuestionError.InvalidCategory(let description) {
            showAlert(title: description, message: "")
        } catch NewQuestionError.EmptyQuestion(let description) {
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
            self.stackViewDistance.isHidden = false
        } else {
            self.stackViewDistance.isHidden = true
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
            self.labelDistance.text = String(format: "%.0f km", sender.value)
        }
    }
    
    
    
    // MARK: - Validation
    
    /**
     Validates if the question is ready to process.
     
     - Throws: NewQuestionError.InvalidCategory, NewQuestionError.EmptyQuestion
     */
    private func validateQuestion() throws {
        guard let _ = self.selectedCategory else {
            throw NewQuestionError.InvalidCategory(description: "No has elegido una categoría.")
        }
        
        guard let text = self.textFieldQuestion.text, text != "" else {
            throw NewQuestionError.EmptyQuestion(description: "No puedes publicar una pregunta vacía")
        }
    }
    
    
    // MARK: - Processing
    
    /**
     Creates a new user's question.
     */
    private func createQuestion() {
        // Create
        let question = Question(context: self.currentUser.managedObjectContext!)
        
        // Set up
        question.category = self.selectedCategory
        question.content = self.textFieldQuestion.text
        question.createdAt = Date()
        question.id = UUID()
        question.latitude = self.selectedCoordinate.latitude
        question.longitude = self.selectedCoordinate.longitude
        
        if self.switchDistance.isOn {
            question.distanceAt = self.sliderDistance.value
        } else {
            question.distanceAt = 0.0
        }
        
        // Link
        question.user = self.currentUser
        
        // Add to the Persistent Store
        saveQuestion()
    }
    
    /**
     Adds the created question to the Persistent Store.
     */
    private func saveQuestion() {
        do {
            // Save
            try self.currentUser.managedObjectContext?.save()
            
            // Confirmation
            showAlert(
                title: "Pregunta creada con éxito",
                message: "Podrás seguirla en \"Mis preguntas\"",
                handler: {
                    self.dismiss(animated: true, completion: nil)
            })
        } catch {
            showAlert(
                title: "No se pudo procesar tu pregunta",
                message: "Inténtalo más tarde"
            )
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
        self.labelCategory.text = value
    }
    
}

// MARK: - TextField Delegate

extension CreateQuestionViewController: UITextFieldDelegate {
    
    /**
     Hides the keyboard when the user finishes editing.
     
     - Parameter textField: Object that triggered the event.
     - Returns: True to hide or false to keep.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
