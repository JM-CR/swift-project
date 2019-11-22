//
//  MainViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController {

    
    // MARK: - Navigation

    /**
     Prepares the controller to perform the segue.
     
     - Parameter segue: Segue's type.
     - Parameter sender: View controller that presents.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "filterSegue":
            // Get parent controller
            guard let navigationVC = self.tabBarController as? NavigationViewController else { return }
            
            // Pass data to destination
            let filtersVC = segue.destination as! FiltersViewController
            filtersVC.currentUser = navigationVC.currentUser
            filtersVC.categories = navigationVC.categories
            
        default:
            return
        }
    }

}
