//
//  Level1ViewController.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/8/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit
import AudioToolbox

class Level1ViewController: UIViewController,  OEEventsObserverDelegate {
 

    @IBOutlet weak var andLabel: UILabel!
    @IBOutlet weak var alohomora: UILabel!
    @IBOutlet weak var sayLabel: UILabel!
    @IBOutlet weak var stoneLabel: UILabel!
    @IBOutlet weak var philosopherLabel: UILabel!
    @IBOutlet weak var gemLabel: UILabel!
    @IBOutlet weak var unlockLabel: UILabel!
    
    var openEarsEventsObserver = OEEventsObserver()
    var shakeSuccessBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        andLabel.layer.shadowColor = UIColor(patternImage: UIImage(named: "crystal1")!).cgColor
        andLabel.textColor = UIColor(patternImage: UIImage(named: "crystal1")!)
        
        gemLabel.layer.shadowColor = UIColor(patternImage: UIImage(named: "crystal1")!).cgColor
        gemLabel.textColor = UIColor(patternImage: UIImage(named: "crystal1")!)
    
        stoneLabel.layer.shadowColor = UIColor(patternImage: UIImage(named: "crystal1")!).cgColor
        stoneLabel.textColor = UIColor(patternImage: UIImage(named: "crystal1")!)
        
        philosopherLabel.layer.shadowColor = UIColor(patternImage: UIImage(named: "crystal1")!).cgColor
        philosopherLabel.textColor = UIColor(patternImage: UIImage(named: "crystal1")!)
        
        alohomora.layer.shadowColor = UIColor(patternImage: UIImage(named: "fire-texture2")!).cgColor
        alohomora.textColor = UIColor(patternImage: UIImage(named: "fire-texture2")!)
        
        sayLabel.layer.shadowColor = UIColor(patternImage: UIImage(named: "fire-texture2")!).cgColor
        sayLabel.textColor = UIColor(patternImage: UIImage(named: "fire-texture2")!)
        
        unlockLabel.layer.shadowColor = UIColor(patternImage: UIImage(named: "fire-texture2")!).cgColor
        unlockLabel.textColor = UIColor(patternImage: UIImage(named: "fire-texture2")!)
        openEarsEventsObserver.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.requestSpeechAuthorization()
        let v = SpeechRecogViewController()
        v.initializeSpeechRecognizer()
        v.startListening()
    }

    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("shake started")
        shakeSuccessBool = true
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("shake ended")
        shakeSuccessBool = true
    }
    
   //================OpenEar Method to get receioved speech ===========================
    
    func pocketsphinxDidReceiveHypothesis(_ hypothesis: String!, recognitionScore: String!, utteranceID: String!) { // Something was heard
        print("Local callback: The received hypothesis is \(hypothesis!) with a score of \(recognitionScore!) and an ID of \(utteranceID!)")
        
        print("You said \(hypothesis!)")
        if hypothesis == "Alohomora" && shakeSuccessBool {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            let v = SpeechRecogViewController()
            v.stopListening()
            shakeSuccessBool = false
            self.performSegue(withIdentifier: "level1Segue", sender: nil)
        }
    }
    
}
