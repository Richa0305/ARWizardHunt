//
//  DesignableLabel.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/11/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit
@IBDesignable
class DesignableLabel: UILabel {
//
//    @IBInspectable var textcolor : UIColor = UIColor(patternImage: UIImage(named: "crystal1")!){
//        didSet{
//        self.textColor = textcolor
//        }
//    }
//
//    @IBInspectable var shadowcolor : UIColor = UIColor(patternImage: UIImage(named: "crystal1")!){
//        didSet{
//            self.layer.shadowColor = shadowcolor.cgColor
//        }
//    }
    
    @IBInspectable var shadowopacity : Float = 1.0{
        didSet{
            self.layer.shadowOpacity = shadowopacity
        }
    }
    
    @IBInspectable var shadowradius : CGFloat = 1.0{
        didSet{
            self.layer.shadowRadius = shadowradius
        }
    }
    @IBInspectable var borderColor : UIColor = UIColor.blue{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth : CGFloat = 1.0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var shadowoffset : CGSize = CGSize(width: 0, height: 3){
        didSet{
            self.layer.shadowOffset = shadowoffset
            
        }
    }
    

}
