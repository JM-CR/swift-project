//
//  CoreDataManager.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/18/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import CoreData
import NotificationCenter

final class CoreDataManager: NSPersistentContainer {
    
    // MARK: - Notification Handling
    
    /**
     Save the current session of the user.
     
     - Parameter notification: Information from the observer.
     */
    @objc private func saveChanges(_ notification: Notification) {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /**
     Register notifications to the app delegate.
     */
    func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        
        // Add observers
        notificationCenter.addObserver(
            self,
            selector: #selector(saveChanges),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(saveChanges),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(saveChanges),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
}
