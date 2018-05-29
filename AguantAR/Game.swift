//
//  Game.swift
//  AguantAR
//
//  Created by Jesus M Martínez de Juan on 28/5/18.
//  Copyright © 2018 CHECHU. All rights reserved.
//

import Foundation

class Game {
    
    var delegate : GameDelegate?
    
    let cooldown = 0.3 // Tiempo que debe esperar el jugador para volver a disparar
    let power = 1 // potencia de cada proyectil
    var health = 100  { // Vida del jugador
        didSet{
            delegate?.healthDidChange()
        }
    }
    
    var lastShot : TimeInterval = 0 // Guarda la ultima vez que ha disparado el usuario
    
    // determina si podemos volver a disparar y en funcion de si ha pasado el tiempo de cooldown
    func playerCanShoot() -> Bool { // runs 60 fps
        let curTime = Date().timeIntervalSince1970
        if(curTime - lastShot > cooldown){
            lastShot = curTime
            return true
        }
        return false
    }
    
    var spawnCount = 0 // Contador
    let spawnFreq = 60 // Frecuencia con la que intentará hacer aparecer a un enemigo
    let spawnProb : UInt32 = 3 // Probabilidad de que aparezca
    
    let maxEnemigos = 20 // maximo numero de enemigos a la vez
    var winLoseFlag : Bool? // Control de si ha ganado, perdido, o aun nada
    
    var goalScore = 20 // Puntuacion necesaria para ganar
    
    var score = 0 { // Guarda el score actual
        didSet{
            delegate?.scoreDidChange()
        }
    }
    
    func apareceEnemigo(numEnemigos: Int) -> Nivel?{ // Decide si un enemigo debe aparecer
        guard numEnemigos < maxEnemigos else { return nil }
        spawnCount += 1
        if(spawnCount == spawnFreq){
            spawnCount = 0
            if(arc4random_uniform(spawnProb) == 0){
                switch (score){
                case 0..<6 :
                    return Nivel(health: 1, power: 1, shotFreq: 80, shotProbHigh: 10, shotProbLow: 2, type: .diana)
                case 6..<11 :
                    return Nivel(health: 3, power: 2, shotFreq: 60, shotProbHigh: 10, shotProbLow: 2, type: .roto2)
                case 11..<16 :
                    return Nivel(health: 5, power: 3, shotFreq: 30, shotProbHigh: 20, shotProbLow: 4, type: .alonso)
                case 16..<21 :
                    return Nivel(health: 1, power: 1, shotFreq: 0, shotProbHigh: 0, shotProbLow: 0, type: .jorge)
                default:
                    print("adios")
                }
            }
            
        }
        return nil
    }
}

protocol GameDelegate {
    func scoreDidChange()
    func healthDidChange()
}
