//
//  QuestionTableViewCell.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/24/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var imageViewLike: UIImageView!
    
    @IBOutlet weak var labelLike: UILabel!
    @IBOutlet weak var labelReport: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelMessages: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    
    // MARK: Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
