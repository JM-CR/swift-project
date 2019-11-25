//
//  AnswerTableViewCell.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/24/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var answerAutor: UILabel!
    @IBOutlet weak var answerContent: UILabel!
    @IBOutlet weak var answerDate: UILabel!
    
    @IBOutlet weak var imageViewLike: UIImageView!
    @IBOutlet weak var totalLikes: UILabel!
    
    
    // MARK: - Cell Liefe Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
