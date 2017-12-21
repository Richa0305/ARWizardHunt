//
//  WelcomeViewController.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/9/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var wizWandImage: UIImageView!
    @IBOutlet weak var wizHeadLabel: UILabel!
    @IBOutlet weak var hatButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [UIViewAnimationOptions.repeat,UIViewAnimationOptions.allowUserInteraction], animations: {
            self.hatButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
        wizHeadLabel.layer.shadowColor = UIColor(patternImage: UIImage(named: "Y3")!).cgColor
        wizHeadLabel.textColor = UIColor(patternImage: UIImage(named: "Y3")!)
        //wizWandImage.setco
    }
    
    @IBAction func hatButtonAction(_ sender: Any) {
       // PlaySound.playSound(fileName: "explosion", extn: "mp3")
    }
}
