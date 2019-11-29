//
//  NotificationTableViewCell.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/28/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var switchActive: UISwitch!
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
