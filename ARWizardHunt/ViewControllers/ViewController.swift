//
//  ViewController.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/7/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreMotion
import Speech

class ViewController: UIViewController, ARSCNViewDelegate,  OEEventsObserverDelegate , IdeasViewControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var currentlySelectedNode:SCNNode?
    let emitter = Emitter.getSnow(with: #imageLiteral(resourceName: "congrates3"))
    var modeType:String?
    var level1 = ["diamond","ruby","sapphire","topaz","gem1","gem2","gem3","gem4","gem9"]
    var level1finalStone = "stone"
    var animator: UIDynamicAnimator? = nil;
    let gravity = UIGravityBehavior()
    var shakeStartedBool = false
    var level1Collected = Set<String>()
    var openEarsEventsObserver = OEEventsObserver()
    let scoreLabel = UILabel()
    var ideaType:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        openEarsEventsObserver.delegate = self
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(20, 20, 20)
        
        sceneView.scene.rootNode.addChildNode(cameraNode)
        
        
        addButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration, options: ARSession.RunOptions.removeExistingAnchors)
        modeType = "WINTER"
        if modeType == "WINTER" {
             makeItShow()
        }
    }

    func makeItShow(){

//        let emitter = Emitter.getSnow(with: #imageLiteral(resourceName: "snowflake"))
//        emitter.emitterPosition = CGPoint(x: view.frame.width/2, y: 0)
//        emitter.emitterSize = CGSize(width: view.frame.width, height: 2)
//        sceneView.layer.addSublayer(emitter)

        let snowPlane = SCNPlane(width: 15, height: 5)
        let snowNode = SCNNode(geometry: snowPlane)
        
        snowPlane.materials.first?.diffuse.contents = UIColor.clear
        snowNode.position = SCNVector3(0, 7, 0)
        snowNode.eulerAngles = SCNVector3(Float(Double.pi/2), Float(0.0), Float(0.0))
        
        let field = SCNPhysicsField.noiseField(smoothness: 1, animationSpeed: 0.25)
        field.falloffExponent = 0
        field.strength = 0.5
        
        snowNode.physicsField = field
        //snowNode.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
        field.categoryBitMask = 2
        snowNode.categoryBitMask = 2
        snowNode.name = "snow"
        sceneView.scene.rootNode.addChildNode(snowNode)
        
        let snowParticleSystem = SCNParticleSystem()
        snowParticleSystem.birthRate = 2000
        snowParticleSystem.particleLifeSpan = 20
        snowParticleSystem.warmupDuration = 20
        snowParticleSystem.isAffectedByGravity = false
        snowParticleSystem.acceleration = SCNVector3(0, -0.25, 0)
        snowParticleSystem.dampingFactor = 0.5
        snowParticleSystem.emitterShape = snowNode.geometry!
        snowParticleSystem.particleColor = UIColor.white
        snowParticleSystem.particleSize = 0.002
        
        snowNode.addParticleSystem(snowParticleSystem)
    }
    
    func addObject(forObj:String){
        
        var shapeNode:SCNGeometry?
        if forObj == "diamond" {
            shapeNode = SCNCone(topRadius: 0.0, bottomRadius: 0.2, height: 0.3)
        }else if forObj == "ruby"{
            shapeNode = SCNSphere(radius: 0.2)
        }else if forObj == "stone"{
            shapeNode =  SCNPyramid(width: 0.5, height: 0.6, length: 0.8)
        }else{
            shapeNode = SCNPyramid(width: 0.3, height: 0.3, length: 0.3)
        }
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: forObj)
        shapeNode!.materials = [material]
        
        let cubeNode = SCNNode(geometry: shapeNode)
        let xPos = randomPosition(lowerBound: -3, upperBound: 3)
        let yPos = randomPosition(lowerBound: -3, upperBound: 3)
        let zPos = randomPosition(lowerBound: -3, upperBound: 3)
        print("x \(xPos) y \(yPos) z \(zPos)")
        cubeNode.position =  SCNVector3(xPos, -yPos, zPos)
        cubeNode.name = forObj
        
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.toValue = NSValue(scnVector4: SCNVector4(0, 0, 1, Float(CGFloat(2 * Double.pi))))
        spin.fromValue = NSValue(scnVector4: SCNVector4(0, 0, 1, 0))
        spin.duration = 3
        spin.repeatCount = .infinity
        cubeNode.addAnimation(spin, forKey: "spin around")
        
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }
    
    func showBomb(forObj:String, vector:SCNVector3){
        
        var shapeNode:SCNGeometry?
        shapeNode = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.2)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: forObj)
        shapeNode!.materials = [material]
        let cubeNode = SCNNode(geometry: shapeNode)
       
        cubeNode.position =  vector
        cubeNode.name = forObj
     
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func nodeWithFile(path: String) -> SCNNode {
        
        if let scene = SCNScene(named: path) {
            
            let node = scene.rootNode.childNodes[0] as SCNNode
            return node
            
        } else {
            print("Invalid path supplied")
            return SCNNode()
        }
        
    }
    func randomPosition(lowerBound:Float,upperBound:Float) -> Float{
        return Float(arc4random()) / Float(UInt32.max) * (lowerBound - upperBound) + upperBound
        
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
       print("shake started")
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("shake ended")
        if !shakeStartedBool {
            shakeStartedBool = true
            sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            for level in level1 {
                addObject(forObj: level)
            }
            
        }
    
        
    }
    func addButton() {
        let button = UIButton()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("Add a CUBE", for: .normal)
        button.setImage(UIImage(named: "idea"), for: UIControlState.normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(showSuggestions(sender:)) , for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 65.0).isActive = true
        button.centerXAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        
        let backbutton = UIButton()
        view.addSubview(backbutton)
        backbutton.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("Back", for: .normal)
        backbutton.setImage(UIImage(named: "back"), for: UIControlState.normal)
        backbutton.setTitleColor(UIColor.red, for: .normal)
        backbutton.backgroundColor = UIColor.clear
        backbutton.addTarget(self, action: #selector(goBack(sender:)) , for: .touchUpInside)
        
        backbutton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 65.0).isActive = true
        backbutton.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 30.0).isActive = true
        
        
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("Back", for: .normal)
        scoreLabel.text = "0/10"
        scoreLabel.textColor = UIColor.yellow
        scoreLabel.font = UIFont(name: "ParryHotter", size: 40)
        scoreLabel.backgroundColor = UIColor.clear
        scoreLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5.0).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 70.0).isActive = true
        //button.heightAnchor.constraint(equalToConstant: 50)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let location = touch.location(in: sceneView)
            let hitlist = sceneView.hitTest(location, options: nil)
            if let hitObj = hitlist.first{
                let selectedNode = hitObj.node
                self.currentlySelectedNode = selectedNode
                level1Collected.insert(selectedNode.name!)
                if self.currentlySelectedNode?.name != "snow"{
                    //PlaySound.playSound(fileName: "explosion", extn: "mp3")
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.currentlySelectedNode?.runAction(SCNAction.scale(by: 30, duration: 3), forKey: "scale", completionHandler: {
                        self.currentlySelectedNode?.removeFromParentNode()
                        
                        DispatchQueue.main.async {
                            self.scoreLabel.text = "\(self.level1Collected.count)/10"
                            if self.level1Collected.count == 1{
                                self.ideaType = "FinalHelpLevel1"
                                self.performSegue(withIdentifier: "showIdeaBlock", sender: nil)
                                self.addObject(forObj: self.level1finalStone)
                            }
                            if self.level1Collected.count == 2 {
                                        self.emitter.isHidden = false
                                        self.emitter.emitterPosition = CGPoint(x: self.view.frame.width/2, y: 0)
                                        self.emitter.emitterSize = CGSize(width: self.view.frame.width, height: 2)
                                        self.sceneView.layer.addSublayer(self.emitter)
                                        self.ideaType = "Level1Completed"
                                        self.performSegue(withIdentifier: "showIdeaBlock", sender: nil)
                            }
                        }
                      
                        if self.modeType == "WINTER"{
                            self.makeItShow()
                        }
                    })
                }
//
//                let v = SpeechRecogViewController()
//                v.initializeSpeechRecognizer()
//                v.startListening()
              
            }
        }
    }
    
    //================OpenEar Method to get receioved speech ===========================
    
    func pocketsphinxDidReceiveHypothesis(_ hypothesis: String!, recognitionScore: String!, utteranceID: String!) { // Something was heard
        print("Local callback: The received hypothesis is \(hypothesis!) with a score of \(recognitionScore!) and an ID of \(utteranceID!)")
        
        print("You said \(hypothesis!)")
        if hypothesis == "Reducto" {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            let v = SpeechRecogViewController()
            v.stopListening()
            //makeItShow()
            if self.currentlySelectedNode?.name != "snow"{
                //PlaySound.playSound(fileName: "explosion", extn: "mp3")
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.currentlySelectedNode?.runAction(SCNAction.scale(by: 30, duration: 3), forKey: "scale", completionHandler: {
                        self.currentlySelectedNode?.removeFromParentNode()
                })
            }
        }
    }
    
    
    @objc func showSuggestions(sender:UIButton){
        self.performSegue(withIdentifier: "showIdeaBlock", sender: nil)
    }
    @objc func goBack(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    func playAgain(){
        
        reset()
    }
    func reset(){
        print("reset called")
        self.ideaType = ""
        scoreLabel.text = "0/10"
        level1Collected.removeAll()
        emitter.birthRate = 0
        emitter.lifetime = 0
        emitter.isHidden = true
        
        for ch in sceneView.scene.rootNode.childNodes{
            ch.removeFromParentNode()
        }
        shakeStartedBool = false
    }
    func goToMainMenu(){
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIdeaBlock" {
            let dest = segue.destination as! IdeasViewController
            dest.delegate = self
            dest.suggestionType = ideaType
        }
    }
}
