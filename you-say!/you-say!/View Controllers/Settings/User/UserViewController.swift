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
    
    // MARK: Properties
    
    var currentUser: User!
    
    
    // MARK: - Actions
    
    @IBAction func botonRegresarPresionado(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
