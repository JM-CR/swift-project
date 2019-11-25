//
//  Question.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/25/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

extension Question {
    
    // MARK: - Sort
    
    var answersByDate: [Answer]? {
        guard let answers = self.answers as? Set<Answer> else {
            return nil
        }
        
        return answers.sorted(by: {
            guard let answer0 = $0.createdAt else { return true }
            guard let answer1 = $1.createdAt else { return true }
            return answer0 > answer1
        })
    }
    
}
