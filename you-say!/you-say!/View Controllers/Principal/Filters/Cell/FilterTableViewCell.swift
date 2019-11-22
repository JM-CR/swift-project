//
//  CategoryTableViewCell.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/21/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var categoryDescription: UILabel!
    
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
