//
//  NavigationViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/18/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit
import CoreData

class NavigationViewController: UITabBarController {

    // MARK: - Properties
    
    let categories = [
        "Animales",
        "Arte",
        "Ciencia",
        "Comida",
        "Entretenimiento",
        "Familia",
        "Filosofía",
        "Finanzas",
        "Libros",
        "Música",
        "Psicología",
        "Relaciones",
        "Salud",
        "Tecnología",
        "Trabajo",
        "Viajes"
    ]
    
    let notifications = [
        "Nueva respuesta",
        "Nuevo me gusta",
        "Pregunta reportada"
    ]
    
    // MARK: Core Data Model
    
    var currentUser: User!

    // MARK: User Notifications Center
    
    var notificationsManager = NotificationsManager()
    
}
