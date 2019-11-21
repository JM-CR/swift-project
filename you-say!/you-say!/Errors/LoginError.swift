//
//  LoginError.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/20/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

enum LoginError: Error {
    case InvalidUser(description: String)
}
