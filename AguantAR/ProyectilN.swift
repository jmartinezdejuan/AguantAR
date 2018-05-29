//
//  ProyectilN.swift
//  AguantAR
//
//  Created by Jesus M Martínez de Juan on 28/5/18.
//  Copyright © 2018 CHECHU. All rights reserved.
//

import UIKit
import ARKit

class ProyectilN: SCNNodeContainer {
    
    var initialPosition : SCNVector3!
    var direction : SCNVector3!
    var type : TipoEnemigo
    var node : SCNNode!
    
    init(initialPosition: SCNVector3, direction: SCNVector3, type: TipoEnemigo){
        self.initialPosition = initialPosition
        self.direction = direction.normalized()
        self.type = type
        self.node = createNode()
        self.node.position = initialPosition
    }
    
    func createNode() -> SCNNode{
        
        // Crea una esfera roja
        let geometry = SCNSphere(radius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = type == .player ? UIColor.red : UIColor.green
        geometry.materials = [material]
        let sphereNode = SCNNode(geometry: geometry)
        
        sphereNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        sphereNode.physicsBody?.contactTestBitMask = type == .player ? PhysicsMask.playerBullet : PhysicsMask.enemyBullet
        sphereNode.physicsBody?.isAffectedByGravity = false
        return sphereNode
    }
    
    /// Se ejecuta cada vez que hay un cambio de frame
    func move() -> Bool{
        
        self.node.position += direction/60 //Travels 1 m/s
        if self.node.position.distance(vector: initialPosition) > 3 {
            return false
        }
        return true
    }
    
}
