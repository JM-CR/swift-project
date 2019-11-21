//
//  ViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    // MARK: Properties
    
    var emailToAuth: String {
        return self.textFieldEmail.text!
    }
    
    var passwordToAuth: String {
        return self.textFieldPassword.text!
    }
    
    // MARK: Core Data
    
    var viewContext: NSManagedObjectContext!
    
    private var fetchedLogin: Login? {
        // Create request
        let fetchRequest: NSFetchRequest<Login> = Login.fetchRequest()
        
        // Configure request
        fetchRequest.predicate = NSPredicate(format: "email == %@", self.emailToAuth)
        
        // Get results
        let fetchedResults = try? self.viewContext.fetch(fetchRequest)
        return fetchedResults?.count == 0 ? nil : fetchedResults?.first
    }
    
    
    // MARK: - View Life Cycle
    
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
    
    // MARK: Gestures
    
    /**
     Hides the keyboard when the user taps on the screen.
     */
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    
    // MARK: - Auth
    
    /**
     Searchs the user in the persistent store.
     
     - Throws: LoginError.InvalidUser
     */
    private func validateCredentials() throws {
        guard let fetchedLogin = self.fetchedLogin else {
            throw LoginError.InvalidUser(description: "El usuario no existe.")
        }
        
        guard fetchedLogin.password == self.passwordToAuth else {
            throw LoginError.InvalidUser(description: "Contraseña incorrecta.")
        }
    }
    
    
    // MARK: - Navigation
    
    /**
     Authenticates the user if correct credentials are introduced.
     
     - Parameter segue: Segue's type.
     - Parameter sender: View controller that presents.
     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Flag that validates the segue
        var flag = true
        
        // Check auth
        if identifier == "authSegue" {
            do {
                // Try to authenticate
                try validateCredentials()
                
            } catch LoginError.InvalidUser(let description) {
                showAlert(title: "No fue posible iniciar sesión", message: description)
                flag.toggle()
            } catch {
                flag.toggle()
            }
        }
        
        return flag
    }
    
    /**
     Prepares the controller to perform the segue.
     
     - Parameter segue: Segue's type.
     - Parameter sender: View controller that presents.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "createAccountSegue":
            // Pass data to destination
            let newUserVC = segue.destination as! NewUserViewController
            newUserVC.viewContext = self.viewContext
            
        case "authSegue":
            // Pass data to destination
            let navigationVC = segue.destination as! NavigationViewController
            navigationVC.viewContext = self.viewContext
            
        default:
            return
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
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
