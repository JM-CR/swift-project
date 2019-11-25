//
//  User.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/24/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

extension User {
    
    // MARK: - Sort
    
    var questionsByDate: [Question]? {
        guard let questions = self.questions as? Set<Question> else {
            return nil
        }
        
        return questions.sorted(by: {
            guard let question0 = $0.createdAt else { return true }
            guard let question1 = $1.createdAt else { return true }
            return question0 > question1
        })
    }
}
