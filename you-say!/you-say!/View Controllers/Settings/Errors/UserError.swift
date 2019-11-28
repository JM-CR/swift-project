//
//  UserError.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/28/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

enum UserError: Error {
    case EmptyName(description: String)
    case EmptyLastName(description: String)
}
