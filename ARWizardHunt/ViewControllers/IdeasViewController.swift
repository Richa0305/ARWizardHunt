//
//  IdeasViewController.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/16/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit
protocol IdeasViewControllerDelegate {
    func playAgain()
    func goToMainMenu()
}

class IdeasViewController: UIViewController {

    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    @IBOutlet weak var line3: UILabel!
    @IBOutlet weak var line4: UILabel!
    @IBOutlet weak var line5: UILabel!
    @IBOutlet weak var line6: UILabel!
    @IBOutlet weak var mainMenuButton: UIButton!
    var delegate: IdeasViewControllerDelegate?
    var suggestionType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if suggestionType == "FinalHelpLevel1" {
            mainLabel.text = "Great!!!"
            line1.text = "You have found 9 Gems!"
            line2.text = "Now look for philosopher stone"
            line3.text = "Its some where around you "
            line4.text = "Find it and Destroy it"
            line5.text = "Touch the stone and say "
            line6.text = "“Bombarda Maxima” to destroy it"
        }else if suggestionType == "Level1Completed"{
            mainLabel.text = "Bravo!!!"
            mainLabel.font = UIFont(name: "HarryP-Regular", size: 60)
            line1.text = "You destroyed All the Gems"
            line2.isHidden = true
            line3.text = "And the Philosopher Stone!!!"
            line4.isHidden = true
            line5.isHidden = true
            line6.isHidden = true
            mainMenuButton.isHidden = false
            playAgainButton.isHidden = false
        }
       
    }

    @IBAction func playAgainButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.playAgain()
    }
    @IBAction func mainMenuButtonAction(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
       delegate?.goToMainMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

}
