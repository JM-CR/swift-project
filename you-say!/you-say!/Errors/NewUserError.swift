//
//  InputError.swift
//  Posesionista
//
//  Created by Josue Mosiah Contreras Rocha on 10/31/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import Foundation

enum NewUserError: Error {
    case EmptyField(description: String)
    case GenderNotChosen(description: String)
    case UnderMinimumAge(description: String)
}