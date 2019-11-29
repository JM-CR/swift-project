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
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldAlias: UITextField!
    @IBOutlet weak var textFieldCreatedAt: UITextField!
    @IBOutlet weak var textFieldBirthDate: UITextField!
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewAlias: UIView!
    @IBOutlet weak var viewCreatedAt: UIView!
    @IBOutlet weak var viewBirthDate: UIView!
    
    // MARK: Properties
    
    var currentUser: User!
    var dateFormatter: DateFormatter!
    
    lazy var initialName = self.currentUser.name
    lazy var initialLastName = self.currentUser.lastName
    lazy var initialAlias = self.currentUser.alias
    
    
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
        self.viewLastName.layer.cornerRadius = 15
        self.viewCreatedAt.layer.cornerRadius = 15
        self.viewBirthDate.layer.cornerRadius = 15
        
        // Text field
        self.textFieldName.backgroundColor = .clear
        self.textFieldName.borderStyle = .none
        
        self.textFieldAlias.backgroundColor = .clear
        self.textFieldAlias.borderStyle = .none
        
        self.textFieldLastName.backgroundColor = .clear
        self.textFieldLastName.borderStyle = .none
        
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
        self.textFieldLastName.delegate = self
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
        self.textFieldName.text = self.currentUser.name
        self.textFieldLastName.text = self.currentUser.lastName
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
        do {
            // Validate correct input
            try validateData()
            
            // Check changes
            if detectChanges() {
                try? self.currentUser.managedObjectContext?.save()
            }
            
            dismiss(animated: true, completion: nil)
            
        } catch UserError.EmptyName(let description) {
            showAlert(title: "Campo inválido", message: description) {
                self.textFieldName.becomeFirstResponder()
            }
        } catch UserError.EmptyLastName(let description) {
            showAlert(title: "Campo inválido", message: description) {
                self.textFieldLastName.becomeFirstResponder()
            }
        } catch {
            showAlert(title: "Error desconocido", message: "Inténtalo más tarde")
        }
    }
    
    
    // MARK: - Validation
    
    /**
     Checks if the user has left an empty field.
     
     - Throws: UserError.EmptyField
     */
    private func validateData() throws {
        guard let name = self.textFieldName.text, !name.isEmpty else {
            throw UserError.EmptyName(description: "Introduce un nombre válido")
        }
        
        guard let lastName = self.textFieldLastName.text, !lastName.isEmpty else {
            throw UserError.EmptyLastName(description: "Introduce un apellido válido")
        }
    }
    
    /**
     Detects if the user has changed a field.
     
     - Returns: True if there is a change.
     */
    private func detectChanges() -> Bool {
        var flag = false
        
        // Evaluate entries
        if self.textFieldName.text! != self.initialName {
            self.currentUser.name = self.textFieldName.text
            flag = true
        }
        
        if self.textFieldLastName.text! != self.initialLastName {
            self.currentUser.lastName = self.textFieldLastName.text
            flag = true
        }
        
        if self.textFieldAlias.text! != self.initialAlias {
            self.currentUser.alias = self.textFieldAlias.text
            flag = true
        }
        
        return flag
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
