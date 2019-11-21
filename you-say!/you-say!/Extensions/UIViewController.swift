//
//  UIViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/19/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     Presents a simple alert without handlers.
     
     - Parameter title: Title to display in the alert.
     - Parameter message: Message to display in the alert.
     */
    func showAlert(title: String, message: String) {
        // Create alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add actions
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    /**
     Presents a simple alert without handlers.
     
     - Parameter title: Title to display in the alert.
     - Parameter message: Message to display in the alert.
     - Parameter handler: Closure to execute at completion.
     */
    func showAlert(title: String, message: String, handler: @escaping () -> Void) {
        // Create alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add actions
        let action = UIAlertAction(title: "Ok", style: .default) { alert in
            handler()
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}
