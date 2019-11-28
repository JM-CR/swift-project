//
//  DesignableView.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 11/19/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableView: UIView {
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            self.layer.shadowColor = self.shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            self.layer.shadowRadius = self.shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat = 0.0 {
        didSet {
            layer.shadowOpacity = Float(self.shadowOpacity)
        }
    }
    
    @IBInspectable var shadowOffsetY: CGFloat = 0.0 {
        didSet {
            layer.shadowOffset.height = self.shadowOffsetY
        }
    }
    
    @IBInspectable var shadowOffsetX: CGFloat = 0.0 {
        didSet {
            layer.shadowOffset.width = self.shadowOffsetX
        }
    }
    
}
