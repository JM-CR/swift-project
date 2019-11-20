//
//  ViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    
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
    
    // MARK:  Gestures
    
    /**
     Hides the keyboard when the user taps on the screen.
     */
    @objc func didTapView(){
        self.view.endEditing(true)
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
