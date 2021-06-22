//
//  ViewController.swift
//  ARDicee
//
//  Created by Kejvi Peti on 2021-06-21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, DiceDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var dice = Dice()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        dice.delegate = self
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - Add dice on touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            guard let query = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneInfinite, alignment: .horizontal) else {
                print("No plane on touched location")
                return
            }
            
            let results = sceneView.session.raycast(query)
            guard let hitResult = results.first else {
               print("No surface found")
               return
            }
            dice.addDice(at: hitResult)
        }
    }
    
    //MARK: - Dice Roll and Transformation IBAction Methods
     
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        dice.rollAll()
    }
  
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        dice.rollAll()
    }
    
    @IBAction func removeAllDice(_ sender: Any) {
        dice.removeDice()
    }
    
    //MARK: - Dice Delegate method
    
    func diceWasAdded(with node: SCNNode){
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    //MARK: - ARSCNView DelegateMethod
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        let planeNode = dice.createPlane(with: planeAnchor)
        
        node.addChildNode(planeNode)
    }
    
}
