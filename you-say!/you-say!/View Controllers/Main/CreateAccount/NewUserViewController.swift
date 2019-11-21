//
//  NewUserViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit
import CoreData

class NewUserViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldAlias: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK:  Properties

    var gender: String?
    var emailToSearch: String {
        return self.textFieldEmail.text!
    }

    // MARK: Core Data
    
    var viewContext: NSManagedObjectContext!
    
    private var fetchedLogin: Login? {
        // Create request
        let fetchRequest: NSFetchRequest<Login> = Login.fetchRequest()
        
        // Configure request
        fetchRequest.predicate = NSPredicate(format: "email == %@", self.emailToSearch)
        
        // Get results
        let fetchedResults = try? self.viewContext.fetch(fetchRequest)
        return fetchedResults?.count == 0 ? nil : fetchedResults?.first
    }
    
    
    // MARK: - View Life Cycle
    
    /**
     Perform an action after the view is instantiated.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial setup
        setupDelegates()
        setupGestures()
        setupViews()
    }
    
    // MARK: Setup
    
    /**
     Sets the delegates for the view controller.
     */
    private func setupDelegates() {
        self.textFieldName.delegate = self
        self.textFieldLastName.delegate = self
        self.textFieldAlias.delegate = self
        self.textFieldEmail.delegate = self
        self.textFieldPassword.delegate = self
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
     Configures initial values for views in the form.
     */
    private func setupViews() {
        let today = Date()
        self.datePicker.maximumDate = today
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
     Returns to the login view controller.
     
     - Parameter sender: Object that triggered the action.
     */
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Creates a new account for the user.
     
     - Parameter sender: Object that triggered the action.
     */
    @IBAction func createButtonPressed(_ sender: UIButton) {
        do {
            // Validate input data
            try validateTextFields()
            try validateGender()
            try validateAge()
            self.view.endEditing(true)
            
            // Create new account
            createUser()
            
        } catch NewUserError.EmptyField(let description) {
            showAlert(title: "Campo inválido", message: description)
        } catch NewUserError.GenderNotChosen(let description) {
            showAlert(title: "Elige un sexo", message: description)
        } catch NewUserError.UnderMinimumAge(let description) {
            showAlert(title: "Eres menor de edad", message: description)
        } catch { }
    }
    
    
    // MARK: - Validation
    
    /**
     Validate the data introduced by the user in the textfields.
     
     - Throws: NewUserError.EmptyField
     */
    private func validateTextFields() throws {
        // Validate name
        guard let name = self.textFieldName.text, !name.isEmpty else {
            throw NewUserError.EmptyField(description: "Debes introducir un nombre.")
        }
        
        // Validate last name
        guard let lastName = self.textFieldLastName.text, !lastName.isEmpty else {
            throw NewUserError.EmptyField(description: "Debes introducir un apellido.")
        }
        
        // Validate email
        guard let email = self.textFieldEmail.text, !email.isEmpty else {
            throw NewUserError.EmptyField(description: "Debes introducir un correo.")
        }
        
        guard self.fetchedLogin == nil else {
            throw NewUserError.EmptyField(description: "Un usuario ya se registró con ese correo.")
        }
        
        // Validate password
        guard let password = self.textFieldPassword.text, !password.isEmpty else {
            throw NewUserError.EmptyField(description: "Debes introducir una contraseña.")
        }
        
        guard password.count > 7 else {
            throw NewUserError.EmptyField(description: "Tu contraseña debe tener 8 caracteres como mínimo.")
        }
    }
    
    /**
     Validate the selected gender by the user.
     
     - Throws: NewUserError.GenderNotChosen
     */
    private func validateGender() throws {
        guard let _ = self.gender else {
            throw NewUserError.GenderNotChosen(description: "")
        }
    }
    
    /**
     Validate if the user has a minimum of 18 years.
     
     - Throws: NewUserError.UnderMinimumAge
     */
    private func validateAge() throws {
        // Calculate years from birth date
        let dateOfBirth = self.datePicker.date
        let today = Date()
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let age = gregorian.dateComponents([.year], from: dateOfBirth, to: today)
        
        // Validate
        guard let years = age.year, years >= 18 else {
            throw NewUserError.UnderMinimumAge(description: "Para usar la aplicación debes ser mayor de edad.")
        }
    }
    
    
    // MARK: - User Creation
    
    /**
     Adds a new account to Core Data.
     */
    private func createUser() {
        // Create credentials for user
        let login = Login(context: self.viewContext)
        login.email = self.textFieldEmail.text
        login.password = self.textFieldPassword.text
        login.createdAt = Date()
        
        // Create user account
        let user = User(context: self.viewContext)
        user.name = self.textFieldName.text
        user.lastName = self.textFieldLastName.text
        user.alias = self.textFieldAlias.text
        user.gender = self.gender
        user.birthDate = self.datePicker.date
        user.id = UUID()
        
        // Link between model objects
        user.login = login
        
        // Save
        do {
            try self.viewContext.save()
            showAlert(title: "Usuario creado con éxito", message: "Ya puedes iniciar sesión.") {
                self.dismiss(animated: true, completion: nil)
            }
        } catch {
            showAlert(title: "Intenta más tarde", message: "Hubo un error al crear tu cuenta")
        }
    }
    
    
    // MARK: - Navigation

    /**
     Prepares the controller to perform the segue.
     
     - Parameter segue: Segue's type.
     - Parameter sender: View controller that presents.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "genderSegue" {
            // Pass data to destination
            let genderVC = segue.destination as! GenderViewController
            genderVC.delegate = self
        }
    }

}

extension NewUserViewController: UITextFieldDelegate {
    
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

extension NewUserViewController: GenderDelegate {
    
    /**
     Update the content for the gender's variable.
     
     - Parameter value: Chosen gender.
     */
    func readyToProcess(value: String) {
        self.gender = value
    }
    
}
