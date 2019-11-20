
//
//  File.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/19/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, actionHandler: @escaping () -> Void) {
        // Create alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add actions
        let action = UIAlertAction(title: "Ok", style: .default) { alertAction in
            actionHandler()
        }
        alert.addAction(action)
        
        // Present
        present(alert, animated: true, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
    
}
