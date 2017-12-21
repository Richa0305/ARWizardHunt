//
//  SpriteViewController.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/16/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit
import ARKit
class SpriteViewController: UIViewController,ARSKViewDelegate {

    @IBOutlet weak var arView: ARSKView!
    override func viewDidLoad() {
        super.viewDidLoad()
        arView.delegate = self
        if let scene = SKScene(fileNamed: "Scene") {
            arView.presentScene(scene)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        arView.session.run(configuration)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
