//
//  GenderDelegate.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/19/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

/**
 Informs that the gender has been chosen by the user.
 */
protocol GenderDelegate: AnyObject {
    func readyToProcess(value: String)
}
