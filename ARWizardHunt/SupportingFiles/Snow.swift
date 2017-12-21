//
//  Snow.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/15/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class Snow:UIView
{
    
    var viewHeight = CGFloat(0)

    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.white.setFill()
        path.fill()
    }
}
