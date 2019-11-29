//
//  NotificationsManager.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UserNotifications

class NotificationsManager {
    
    // MARK: - Properties
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound]
    
    
    // MARK: - Initialization
    
    /**
     Iniitializates the object and asks permission.
     */
    init() {
        self.userNotificationCenter.requestAuthorization(options: self.options) { (granted, error) in
            // Nothing to do
        }
    }
    
    
    // MARK: - Helper Methods
    
    /**
     Creates a notification's alert for the user.
     
     - Parameter title: Notification's title.
     - Parameter subtitle: Notification's subtitle.
     - Parameter body: Content.
     */
    func sendAlert(title: String, subtitle: String, body: String) {
        // Check status
        self.userNotificationCenter.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                // Create
                let content = UNMutableNotificationContent()
                content.title = title
                content.subtitle = subtitle
                content.body =  body
                
                // Create request
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7, repeats: false)
                let request = UNNotificationRequest(identifier: "you_say", content: content, trigger: trigger)
                
                // Post
                self.userNotificationCenter.add(request, withCompletionHandler: nil)
                
            default:
                return
            }
        }
    }
    
}
