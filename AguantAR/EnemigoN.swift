//
//  EnemigoN.swift
//  AguantAR
//
//  Created by Jesus M Martínez de Juan on 28/5/18.
//  Copyright © 2018 CHECHU. All rights reserved.
//

import ARKit
import UIKit

class EnemigoN: SCNNodeContainer {
    var node : SCNNode!
    var nivel : Nivel
    var lastAxis = SCNVector3Make(0, 0, 0)
    
    var spawnCount = 0
    
    
    init(nivel: Nivel, position: SCNVector3, cameraPosition: SCNVector3) {
        
        self.nivel = nivel
        self.node = createNode()
        self.node.position = position
        self.node.rotation = SCNVector4Make(0, 1, 0, 0)
        
        let deltaRotation = getXZRotation(towardsPosition: cameraPosition)
        if deltaRotation > 0 {
            node.rotation.w -= deltaRotation
        }else if deltaRotation < 0 {
            node.rotation.w -= deltaRotation
        }
    }
    // Devuelve el angulo que debe rotar la figura en en el plano XZ para que mire a la direccion deseada
    func getXZRotation(towardsPosition toPosition: SCNVector3) -> Float {
        
        // Crea el vector distancia XZ normalizado
        var unitDistance = (toPosition - node.position).negate()
        unitDistance.y = 0
        unitDistance = unitDistance.normalized()
        
        // Crea el vector direccion XZ normalizado para la figura
        var unitDirection = self.node.convertPosition(SCNVector3Make(0, 0, -1), to: nil) - self.node.position
        unitDirection.y = 0
        unitDirection = unitDirection.normalized()
        
        // Encuentra el angulo que hay entre 2 vectores y usa las direcciones del producto vectorial para determinar su signo
        let axis = unitDistance.cross(vector: unitDirection).normalized()
        let angle = acos(unitDistance.dot(vector: unitDirection))
        return angle * axis.y
    }
    
    private func createNode() -> SCNNode{
        // Establece la escala general para las imagenes
        let scaleFactor = nivel.frontImage.size.width/0.2
        let width = nivel.frontImage.size.width/scaleFactor
        let height = nivel.frontImage.size.height/scaleFactor
        
        // Crea un objeto plano para representar el enemigo por delante
        let geometryFront = SCNPlane(width: width, height: height)
        let materialFront = SCNMaterial()
        materialFront.diffuse.contents = nivel.frontImage
        geometryFront.materials = [materialFront]
        
        // Crea un objeto plano para representar el enemigo por detrás
        let geometryBack = SCNPlane(width: width, height: height)
        let materialBack = SCNMaterial()
        materialBack.diffuse.contents = nivel.backImage
        geometryBack.materials = [materialBack]
        
        // Crea ambos nodos y pone el nodo trasero justo detrás del delantero
        let mainNode = SCNNode(geometry: geometryFront)
        let backNode = SCNNode(geometry: geometryBack)
        backNode.position = SCNVector3Make(0,0,0)
        backNode.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        
        // Controlamos el movimiento del main node gracias al physics body
        mainNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        mainNode.physicsBody?.contactTestBitMask = PhysicsMask.enemy
        mainNode.physicsBody?.isAffectedByGravity = false
        mainNode.addChildNode(backNode)
        return mainNode
    }
    
    /**
     La siguiente funcion se ejecuta cada frame, si devuelve false,
     el enemigo desaparece y se resta vida al jugador
     */
    func move(towardsPosition toPosition : SCNVector3) -> Bool{
        
        // Encuentra el vector distancia entre el enemigo y el jugador y lo normaliza
        let deltaPos = (toPosition - node.position)
        
        // En caso de que colisionen devuelve false
        guard deltaPos.length() > 0.05 else { return false }
        let normDeltaPos = deltaPos.normalized()
        
        // La posicion en y siempre se dirigirá al jugador
        node.position.y += normDeltaPos.y/50
        
        // Toma la distancia del plano XY
        let length = deltaPos.xzLength()
        
        // Si se encuentra cerca del usuario parará de moverse, sino avanzará en direcciona la usuario
        // Si el enemigo está muy cerca del usuario, este avanzará para matarle
        if length > 0.5 || length < 0.1 {
            node.position.x += normDeltaPos.x/250
            node.position.z += normDeltaPos.z/250
            nivel.cercania = false
        }else{
            nivel.cercania = true
        }
        
        // Encuentra el angulo de rotacion para que se quede mirando al jugador
        let goalRotation = getXZRotation(towardsPosition: toPosition)
        
        // Rota una fraccion muy pequeña de ese angulo
        if goalRotation > 0 {
            node.rotation.w -= min(Float.pi/180, goalRotation)
        }else if goalRotation < 0 {
            node.rotation.w -= max(-Float.pi/180, goalRotation)
        }
        
        return true
    }
}
