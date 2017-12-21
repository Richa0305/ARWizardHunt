//
//  Level1GameModeViewController.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/12/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit

class Level1GameModeViewController: UIViewController {

    @IBOutlet weak var winterModeView: UIView!
    @IBOutlet weak var winterModeLabel: UILabel!
    @IBOutlet weak var normalModeLabel: UILabel!
    @IBOutlet weak var gameModeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        winterModeLabel.layer.shadowColor = UIColor(patternImage: UIImage(named: "yellow1")!).cgColor
//        winterModeLabel.textColor = UIColor(patternImage: UIImage(named: "yellow1")!)
//        
//        normalModeLabel.layer.shadowColor = UIColor(patternImage: UIImage(named: "yellow1")!).cgColor
//        normalModeLabel.textColor = UIColor(patternImage: UIImage(named: "yellow1")!)
//        
//        gameModeLabel.layer.shadowColor = UIColor(patternImage: UIImage(named: "yellow1")!).cgColor
//        gameModeLabel.textColor = UIColor(patternImage: UIImage(named: "yellow1")!)
        
        
        makeItShow()
        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeItShow(){
        
        
        let emitter = Emitter.get(with: #imageLiteral(resourceName: "snowball"))
        emitter.emitterPosition = CGPoint(x: winterModeView.frame.width/2 + 5, y: 5)
        emitter.emitterSize = CGSize(width: winterModeView.frame.width - 10, height: 2)
        winterModeView.layer.addSublayer(emitter)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "winterMode" {
            let dest = segue.destination as! ViewController
            dest.modeType = "WINTER"
        }else{
            let dest = segue.destination as! ViewController
            dest.modeType = "NORMAL"
            
            
        }
    }

    
}
