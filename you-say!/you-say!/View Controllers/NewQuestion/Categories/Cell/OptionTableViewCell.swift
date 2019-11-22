//
//  OptionTableViewCell.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/22/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var categoryDescription: UILabel!
    
    
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
