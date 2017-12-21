//
//  SpellTestGameViewController.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 12/1/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit

class SpellTestGameViewController: UIViewController,  OEEventsObserverDelegate  {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var gameScore: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var infoText: DesignableLabel!
    @IBOutlet weak var darkCircleFillView: DesignableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var object1: UIImageView!
    @IBOutlet weak var toggleMenuButton: UIButton!
    var shakeSuccessBool = false
    var touchSuccessBool = false
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    var taskObjects = ["feather","BrokenCauldron","emptyglass","Darkness","Cup","EmptyParchment"]
    var spells = ["wingardium leviosa","Oculus Reparo","Aguamenti","lumos","Accio Gold Cup","Aparecium"]
    var rounds = 0
    var currentObject = "feather"
    var openEarsEventsObserver = OEEventsObserver()
    override func viewDidLoad() {
        super.viewDidLoad()
        currentObject = taskObjects[rounds]
        //nextTask()
        runTimer()
        self.infoText.text = "Your Phone is Your wand! Touch the Screen, Swiss Your Phone and Cast the Spell to make this feather fly!"
        self.object1.image = UIImage(named: "feather")
        openEarsEventsObserver.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.requestSpeechAuthorization()
        let v = SpeechRecogViewController()
        v.initializeSpeechRecognizer()
        v.startListening()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTimerRunning {
            touchSuccessBool = true
            //gameActions()
        }
    }
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("shake started")
        shakeSuccessBool = true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("shake ended")
        shakeSuccessBool = true
    }
    
    func gameActions(){
        timer.invalidate()
        if currentObject == "BrokenCauldron" || currentObject == "emptyglass" {
            UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseOut,  animations: {
                self.object1.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.object1.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }) { (true) in
                if self.currentObject == "BrokenCauldron" {
                    self.object1.image = UIImage(named: "Cauldron")
                    self.nextTask()
                }else if self.currentObject == "emptyglass"{
                    self.nextTask()
                    self.object1.image = UIImage(named: "fullglass")
                }
            }
        }else if currentObject == "feather" {
            
            UIView.animate(withDuration: 2, animations: {
                self.object1.transform = CGAffineTransform(rotationAngle: 5)
                self.object1.transform = CGAffineTransform(translationX: -50, y: -50)
            }, completion: { (true) in
                UIView.animate(withDuration: 2, animations: {
                    self.object1.transform = CGAffineTransform(translationX: 80, y: -200)
                    //self.object1.transform = CGAffineTransform(translationX: -10, y: -self.view.frame.height)
                }, completion: { (true) in
                    UIView.animate(withDuration: 2, animations: {
                        self.object1.transform = CGAffineTransform(translationX: -100, y: -self.view.frame.height)
                    }, completion: { (true) in
                        self.nextTask()
                        self.object1.transform = .identity
                        self.object1.image = nil
                    })
                })
            })
        }else if currentObject == "Darkness"{
            UIView.animate(withDuration: 3, animations: {
                self.background.alpha = 1
            }, completion: { (true) in
                self.nextTask()
            })
        }else if currentObject == "Cup"{
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                
                self.object1.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { (true) in
                self.nextTask()
            })
            
        }else if currentObject == "EmptyParchment"{
            self.object1.alpha = 0.2
            UIView.animate(withDuration: 1, animations: {
                self.object1.alpha = 1
                self.object1.image = UIImage(named: "MapParchment")
            }, completion: { (true) in
                
            })
            
        }
    }
    
    /* Loop through to next tasks in case of succuss in last task  */
    func nextTask(){
        
        if isTimerRunning {
            isTimerRunning = false
            rounds = rounds + 1
            //rounds = 2
            if rounds < taskObjects.count {
                for _ in 0...200{
                    self.showStars()
                }
                gameScore.text = String(Int(gameScore.text!)! + 100)
                let defaults = UserDefaults.standard
                defaults.set(gameScore.text, forKey: "GameScore")
                runTimer()
                currentObject = taskObjects[rounds]
                let overlay = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                overlay.backgroundColor = UIColor.white
                overlay.alpha = 0.2
                self.view.addSubview(overlay)
                UIView.animate(withDuration: 1.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    overlay.alpha = 0.8
                }) { (true) in
                    overlay.removeFromSuperview()
                    if self.currentObject == "BrokenCauldron" {
                        self.infoText.text = "Your Phone is Your wand! Touch the Screen, Swiss Your Phone and Cast the Spell to fix the Broken Cauldron."
                        self.object1.image = UIImage(named: "BrokenCauldron")
                    } else if self.currentObject == "feather" {
                        self.infoText.text = "Your Phone is Your wand! Touch the Screen, Swiss Your Phone and Cast the Spell to make this feather fly!"
                        self.object1.image = UIImage(named: "feather")
                    }else if self.currentObject == "emptyglass" {
                        self.infoText.text = "Your Phone is Your wand! Touch the Screen, Swiss Your Phone and Cast the Spell to fill the glass with Water"
                        self.object1.image = UIImage(named: "emptyglass")
                    }else if self.currentObject == "Darkness" {
                        self.infoText.text = "Your Phone is Your wand! Touch the Screen, Swiss Your Phone and Cast the Spell to bring light!"
                        self.object1.image = nil
                        self.background.alpha = 0
                    }else if self.currentObject == "Cup" {
                        self.infoText.text = "Your Phone is Your wand! Touch the Screen, Swiss Your Phone and Cast the Spell to Summon the gold cup"
                        self.object1.image = UIImage(named: "Cup")
                        self.object1.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    }else if self.currentObject == "EmptyParchment" {
                        self.infoText.text = "Your Phone is Your wand! Touch the Screen, Swiss Your Phone and Cast the Spell to Reveal the secrets of this Parchment"
                        self.object1.image = UIImage(named: self.currentObject)
                    }
                }
            }
        }

    }
        /* show stars on success of each spells  */
        func showStars(){
            let image1: UIImageView =  UIImageView(image: UIImage(named: "star1"))
            image1.frame = CGRect(x: -20 + CGFloat(arc4random_uniform(UInt32(self.view.frame.width))), y: -20  + CGFloat(arc4random_uniform(UInt32(self.view.frame.height))), width: 30, height: 30)
            image1.alpha = 0.0
            image1.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.view.addSubview(image1)
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
                image1.alpha = 1.0
                image1.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion:  { (true) in
                UIView.animate(withDuration: 0.1, delay: 0.5, options: .curveEaseOut, animations: {
                    image1.alpha = 0.0
                }, completion:  { (true) in
                    
                })
            })
        }
       
    

    @IBAction func toggleMenuButtonAction(_ sender: Any) {
        
        if darkCircleFillView.transform == .identity {
            UIView.animate(withDuration: 1, animations: {
                self.darkCircleFillView.transform = CGAffineTransform(scaleX: 11, y: 11)
                self.menuView.transform = CGAffineTransform(translationX: 0, y: -56)
                self.toggleMenuButton.transform = CGAffineTransform(rotationAngle: self.radiansButton(degrees: 180))
            }) { (true) in
            }
        }else{
            UIView.animate(withDuration: 1, animations: {
                self.darkCircleFillView.transform = .identity
                self.menuView.transform = .identity
                self.toggleMenuButton.transform = .identity
            }, completion: { (true) in
            })
        }
    }
    
    func runTimer() {
        seconds = 61
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(SpellTestGameViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        seconds -= 1
        
        if seconds == 0 {
            self.view.layer.removeAllAnimations()
            timer.invalidate()
            isTimerRunning = false
            performSegue(withIdentifier: "gameOverOrSuccess", sender: nil)
            //game over
        }
        timerLabel.text = String(seconds)
    }
    func radians(degrees:Double) -> CGFloat{
        return CGFloat(degrees * Double.pi / 180) * 2.0
    }
    
    func radiansButton(degrees:Double) -> CGFloat{
        return CGFloat(degrees * Double.pi / 180)
    }
    
    //================OpenEar Method to get receioved speech ===========================
    
    func pocketsphinxDidReceiveHypothesis(_ hypothesis: String!, recognitionScore: String!, utteranceID: String!) { // Something was heard
        print("Local callback: The received hypothesis is \(hypothesis!) with a score of \(recognitionScore!) and an ID of \(utteranceID!)")
        
        print("You said \(hypothesis!)")
        if spells[rounds].contains(hypothesis)  && shakeSuccessBool && touchSuccessBool {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            let v = SpeechRecogViewController()
            //v.stopListening()
            shakeSuccessBool = false
            touchSuccessBool = false
            gameActions()
        }
    }
    
}



