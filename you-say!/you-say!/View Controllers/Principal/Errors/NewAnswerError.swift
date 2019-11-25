//
//  NewAnswerError.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/25/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

enum NewAnswerError: Error {
    case EmptyField(description: String)
}
