//
//  GeneralTableViewCell.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/26/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var textFieldCategory: UITextField!
    
    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelTotalLikes: UILabel!
    @IBOutlet weak var labelTotalMesssages: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var imageViewLike: UIImageView!
    
    
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
