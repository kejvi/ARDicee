//
//  Dice.swift
//  ARDicee
//
//  Created by Kejvi Peti on 2021-06-22.
//

import UIKit
import ARKit
import SceneKit

struct Dice {
    
    var diceArray = [SCNNode]()
    
    var delegate : DiceDelegate?
    
    //MARK: - Dice animation and transformation methods
    
    mutating func addDice(at location: ARRaycastResult){
        
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.dae")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true){
            
            diceNode.position = SCNVector3(
                x: location.worldTransform.columns.3.x,
                y: location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                z: location.worldTransform.columns.3.z
            )
            diceArray.append(diceNode)
            
            self.delegate?.diceWasAdded(with: diceNode)
            
        }
    }
    
    mutating func removeDice(){
        for dice in diceArray{
            dice.removeFromParentNode()
        }
    }
    
    func rollAll(){
        if !diceArray.isEmpty{
            for dice in diceArray{
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode){
        
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 10), y: 0, z: CGFloat(randomZ * 10), duration: 0.5))
        
    }
    
    //MARK: - Plane rendering
    
    func createPlane(with planeAnchor: ARPlaneAnchor) -> SCNNode{
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode()
        
        planeNode.position = SCNVector3(x: planeAnchor.center.x, y:0, z: planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        plane.materials = [gridMaterial]
        
        planeNode.geometry = plane
        
        return planeNode
    }
}

protocol DiceDelegate {
    
    func diceWasAdded(with node: SCNNode)
    
}
