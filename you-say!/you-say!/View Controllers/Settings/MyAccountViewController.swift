//
//  MyAccountViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var viewAccount: UIView!
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var viewHelp: UIView!
    @IBOutlet weak var labelID: UILabel!
    
    // MARK: Properties
    
    lazy var currentUser = (self.tabBarController as! NavigationViewController).currentUser
    lazy var notifications = (self.tabBarController as! NavigationViewController).notifications
    
    lazy var dateFormatter: DateFormatter = {
        // Create
        var dateFormatter = DateFormatter()
        
        // Set up
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    
    // MARK: - View Life Cycle
    
    /**
     Loads the id from the current user.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up
        setupViews()
    }
    
    // MARK: Set up
    
    /**
     Initial set up for views.
     */
    private func setupViews() {
        self.labelID.text = self.currentUser!.id!.uuidString
    }
    
    
    // MARK: - Actions
    
    /**
     Presents the AccountVC.
     
     - Parameter sender: Tap recognizer.
     */
    @IBAction func viewAccountTapped(_ sender: UITapGestureRecognizer) {
        // Animate
        UIView.animate(withDuration: 0.7) {
            self.viewAccount.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7062885123)
        }
        
        UIView.animate(withDuration: 0.7) {
            self.viewAccount.backgroundColor = .white
        }
        
        // Present
        let userVC = self.storyboard!.instantiateViewController(withIdentifier: "UserVC") as! UserViewController
        userVC.currentUser = self.currentUser
        userVC.dateFormatter = self.dateFormatter
        present(userVC, animated: true, completion: nil)
    }
    
    /**
     Presents the NotificationVC.
     
     - Parameter sender: Tap recognizer.
     */
    @IBAction func viewNotificationTapped(_ sender: UITapGestureRecognizer) {
        // Animate
        UIView.animate(withDuration: 0.7) {
            self.viewNotification.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7062885123)
        }
        
        UIView.animate(withDuration: 0.7) {
            self.viewNotification.backgroundColor = .white
        }
        
        // Present
        let notificationsVC = self.storyboard!.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsViewController
        notificationsVC.notifications = self.notifications
        notificationsVC.currentUser = self.currentUser
        present(notificationsVC, animated: true, completion: nil)
    }
    
    /**
     Presents the HelpVC.
     
     - Parameter sender: Tap recognizer.
     */
    @IBAction func viewHelpTapped(_ sender: UITapGestureRecognizer) {
        // Animation
        UIView.animate(withDuration: 0.7) {
            self.viewHelp.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7062885123)
        }
        
        UIView.animate(withDuration: 0.7) {
            self.viewHelp.backgroundColor = .white
        }
        
        // Present
        let helpVC = self.storyboard!.instantiateViewController(withIdentifier: "HelpVC") as! HelpViewController
        present(helpVC, animated: true, completion: nil)
    }

}
