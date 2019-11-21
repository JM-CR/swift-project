//
//  GenderViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/19/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class GenderViewController: UIViewController {

    // MARK: - Properties
    
    var gender: String!
    weak var delegate: GenderDelegate?
    
    
    // MARK: - Actions

    /**
     Informs to newUserVC that male was selected.
     
     - Parameter sender: Button that triggered the action.
     */
    @IBAction func maleButtonPressed(_ sender: UIButton) {
        self.delegate?.readyToProcess(value: "M")
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Informs to newUserVC that female was selected.
     
     - Parameter sender: Button that triggered the action.
     */
    @IBAction func femaleButtonPressed(_ sender: UIButton) {
        self.delegate?.readyToProcess(value: "F")
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Informs to newUserVC that other was selected.
     
     - Parameter sender: Button that triggered the action.
     */
    @IBAction func otherButtonPressed(_ sender: UIButton) {
        self.delegate?.readyToProcess(value: "N")
        dismiss(animated: true, completion: nil)
    }
    
}
