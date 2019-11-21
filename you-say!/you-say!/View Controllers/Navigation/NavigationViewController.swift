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
        "Diversión",
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
    
    // MARK: Core Data
    
    var viewContext: NSManagedObjectContext!

}
