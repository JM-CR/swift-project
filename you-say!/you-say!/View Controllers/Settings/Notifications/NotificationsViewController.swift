//
//  NotificationsViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var notifications: [String]!
    var currentUser: User!
    
    
    // MARK: - Actions
    
    /**
     Returns to MyAccoutVC.
     
     - Parameter sender: Button object.
     */
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - TableView Data Source

extension NotificationsViewController: UITableViewDataSource {
    
    /**
     Indicates the number of rows for a given section.
     
     - Parameter tableView: TableView object.
     - Parameter section: Section to query.
     - Returns: Total of rows for section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    /**
     Formats a cell in the tableView.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Current position of cell.
     - Returns: Cell ready to display.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get reusable cell
        let notificationCell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        
        // Set up cell
        notificationCell.category.text = self.notifications[indexPath.row]
        notificationCell.category.sizeToFit()
        
        // Check active filters
        let notificationObjects = self.currentUser.notifications as! Set<Notification>
        if (notificationObjects.contains { $0.category == self.notifications[indexPath.row] }) {
            notificationCell.switchActive.setOn(true, animated: false)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return notificationCell
    }
    
}

// MARK: - TableView Delegate

extension NotificationsViewController: UITableViewDelegate {
    
    /**
     Adds a checkmark when the row is selected.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Position of the selected cell.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let notificationCell = tableView.cellForRow(at: indexPath) as? NotificationTableViewCell {
            notificationCell.switchActive.setOn(true, animated: true)
            
            // Add new filter
            let notification = Notification(context: self.currentUser.managedObjectContext!)
            notification.category = self.notifications[indexPath.row]
            self.currentUser.addToNotifications(notification)
        }
    }
    
    /**
     Removes the checkmark when the row is selected.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Position of the selected cell.
     */
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let notificationCell = tableView.cellForRow(at: indexPath) as? NotificationTableViewCell {
            notificationCell.switchActive.setOn(false, animated: true)
            
            // Remove filter
            let notificationObjects = self.currentUser.notifications as! Set<Notification>
            let notificationToDelete = notificationObjects.filter { $0.category == self.notifications[indexPath.row] }.first!
            self.currentUser.managedObjectContext!.delete(notificationToDelete)
        }
    }
    
}
