//
//  MyAnswersViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class MyAnswersViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    
    // MARK: Core Data
    
    
    // MARK: - View Life Cycle
    
    /**
     Initial setup for the controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial setup
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
     Sets the delegates for the view controller.
     */
    private func setupDelegates() {
        self.textViewContent.delegate = self
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
        self.bottomConstraint.constant = 25 - keyboardFrame.size.height
        
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
     Returns to the generalVC.
     
     - Parameter sender: Button that triggered the action.
     */
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - TableView Data Source

extension MyAnswersViewController: UITableViewDataSource {
    
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
        let answerCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswerTableViewCell
        
        // Get answer
        
        return answerCell
    }
    
}

// MARK: - TableView Delegate

extension MyAnswersViewController: UITableViewDelegate {
    
    /**
     Deselects a row when the user taps on it.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Position of the tapped cell.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - TextField Delegate

extension MyAnswersViewController: UITextViewDelegate {
    
    /**
     Hides the keyboard when the user finishes editing.
     
     - Parameter textView: Object that triggered the event.
     - Returns: True to hide or false to keep.
     */
    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
