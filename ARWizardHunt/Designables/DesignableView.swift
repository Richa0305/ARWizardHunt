//
//  DesignableView.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/12/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit
@IBDesignable
class DesignableView: UIView {

    
    @IBInspectable var cornorRadious: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornorRadious
        }
    }
    
    
    @IBInspectable var borderWidth : CGFloat = 0.0{
        didSet{
            self.layer.borderWidth = borderWidth
            
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
