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
    
    @IBOutlet weak var textViewQuestion: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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
        setupViews()
        setupDelegates()
        setupGestures()
        setupNotifications()
    }
    
    /**
     Remove observers when it is disappearing.
     */
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Setup
    
    /**
     Initial set up for views.
     */
    private func setupViews() {
        // TextView
        self.textViewQuestion.text = "Comparte tu pregunta..."
        self.textViewQuestion.textColor = .lightGray
    }
    
    /**
     Sets the delegates for the view controller.
     */
    private func setupDelegates() {
        self.textViewQuestion.delegate = self
    }
    
    /**
     Sets the initial gestures for the view controller.
     */
    private func setupGestures() {
        // Remove keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.view.addGestureRecognizer(tap)
    }
    
    /**
     Sets the observers for the view controller.
     */
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        
        // Keyboard appearing
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        // Keyboard hiding
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: Gestures
    
    /**
     Hides the keyboard when the user taps on the screen.
     */
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    // MARK: Notifications
    
    /**
     Adjusts the content when the keyboard is appearing.
     
     - Parameter notification: Sent notification.
     */
    @objc func keyboardWillShow(notification: NSNotification) {
        // Get keyboard size
        let info = notification.userInfo!
        let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // Update
        self.bottomConstraint.constant = keyboardFrame.size.height * -1
        
        // Animate
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    /**
     Adjusts the content when the keyboard is hiding.
     
     - Parameter notification: Sent notification.
     */
    @objc func keyboardWillHide(notification: NSNotification) {
        // Update
        self.bottomConstraint.constant = 6
        
        // Animate
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
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
            self.view.endEditing(true)
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
        
        guard let text = self.textViewQuestion.text, text != "" else {
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
        question.content = self.textViewQuestion.text
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

// MARK: - TextView Delegate

extension CreateQuestionViewController: UITextViewDelegate {
    
    /**
     Hides the keyboard when the user finishes editing.
     
     - Parameter textField: Object that triggered the event.
     - Returns: True to hide or false to keep.
     */
    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    /**
     Clears the placeholder when the user is writing.
     
     - Parameter textView: Object that triggered the event.
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    /**
     Adds the placeholder if the textView is empty.
     
     - Parameter textView: Object that triggered the event.
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comparte tu pregunta..."
            textView.textColor = .lightGray
        }
    }
}
