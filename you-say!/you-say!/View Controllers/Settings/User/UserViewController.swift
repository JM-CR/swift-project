//
//  UserViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldAlias: UITextField!
    @IBOutlet weak var textFieldCreatedAt: UITextField!
    @IBOutlet weak var textFieldBirthDate: UITextField!
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewAlias: UIView!
    @IBOutlet weak var viewCreatedAt: UIView!
    @IBOutlet weak var viewBirthDate: UIView!
    
    // MARK: Properties
    
    var currentUser: User!
    var dateFormatter: DateFormatter!
    
    
    // MARK: - View Life Cycle
    
    /**
     Initial set up for the controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up
        setupViews()
        setupDelegates()
        setupGestures()
        setupData()
    }
    
    // MARK: Set up
    
    /**
     Initial set up for views.
     */
    private func setupViews() {
        // Views
        self.viewName.layer.cornerRadius = 15
        self.viewAlias.layer.cornerRadius = 15
        self.viewCreatedAt.layer.cornerRadius = 15
        self.viewBirthDate.layer.cornerRadius = 15
        
        // Text field
        self.textFieldName.backgroundColor = .clear
        self.textFieldName.borderStyle = .none
        
        self.textFieldAlias.backgroundColor = .clear
        self.textFieldAlias.borderStyle = .none
        
        self.textFieldCreatedAt.backgroundColor = .clear
        self.textFieldCreatedAt.borderStyle = .none
        
        self.textFieldBirthDate.backgroundColor = .clear
        self.textFieldBirthDate.borderStyle = .none
    }
    
    /**
     Sets the delegates for the view controller.
     */
    private func setupDelegates() {
        self.textFieldName.delegate = self
        self.textFieldAlias.delegate = self
        self.textFieldCreatedAt.delegate = self
        self.textFieldBirthDate.delegate = self
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
     Initial data for the account.
     */
    private func setupData() {
        // User data
        let name = self.currentUser.name
        let lastName = self.currentUser.lastName
        self.textFieldName.text = "\(name!) \(lastName!)"
        
        self.textFieldAlias.text = self.currentUser.alias
        
        // Dates
        let createdAt = self.currentUser.login!.createdAt!
        self.textFieldCreatedAt.text = self.dateFormatter.string(from: createdAt)
        
        let birthDate = self.currentUser.birthDate!
        self.textFieldBirthDate.text = self.dateFormatter.string(from: birthDate)
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
     Saves the posible changes for the user.
     
     - Parameter sender: Button object.
     */
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - TextField Delegate

extension UserViewController: UITextFieldDelegate {
    
    /**
     Hides the keyboard when the user finishes editing.
     
     - Parameter textView: Object that triggered the event.
     - Returns: True to hide or false to keep.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
