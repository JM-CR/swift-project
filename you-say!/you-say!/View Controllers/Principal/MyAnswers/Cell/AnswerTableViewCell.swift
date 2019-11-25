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
    
    @IBOutlet weak var labelAutor: UILabel!
    @IBOutlet weak var labelAnswerContent: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    
    // MARK: - Cell Liefe Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
