//
//  Nivel.swift
//  AguantAR
//
//  Created by Jesus M Martínez de Juan on 28/5/18.
//  Copyright © 2018 CHECHU. All rights reserved.
//

import UIKit

enum NivelType {
    case diana
    case roto2
    case alonso
    case jorge
    func getImages() -> (front: UIImage, back: UIImage){
        switch self {
        case .alonso: return ( #imageLiteral(resourceName: "alonso2"), #imageLiteral(resourceName: "alonso2"))
        case .roto2: return ( #imageLiteral(resourceName: "roto2"), #imageLiteral(resourceName: "med_invader_back"))
        case .diana: return ( #imageLiteral(resourceName: "small_invader"), #imageLiteral(resourceName: "small_invader"))
        case .jorge: return ( #imageLiteral(resourceName: "caraJorge"), #imageLiteral(resourceName: "caraJorge"))
        }
    }
}


class Nivel {
    
    var health : Int
    let power : Int
    let scoreReward : Int
    var shotCount = 0
    let shotFreq : Int // Frecuencia con la que intenta disparar
    var shotProb : Int { //Probabilidad de acierto al disparar = 1/shotProb)
        return cercania ? shotProbHigh : shotProbLow
    }
    private let shotProbHigh : Int
    private let shotProbLow : Int
    
    var cercania = false
    let frontImage : UIImage
    let backImage : UIImage
    
    init(health: Int, power: Int, shotFreq: Int, shotProbHigh: Int, shotProbLow: Int, type: NivelType){
        
        self.health = health
        self.scoreReward = health * 10
        self.power = power
        self.shotFreq = shotFreq
        self.shotProbLow = shotProbLow
        self.shotProbHigh = shotProbHigh
        
        let images = type.getImages()
        self.frontImage = images.front
        self.backImage = images.back
        
    }
    
    func shouldShoot() -> Bool { // runs 60 fps
        shotCount += 1
        var a = false
        if(shotCount == shotFreq){
            shotCount = 0
            //arc4random_uniform(X) devuelve un numero al azar entre 0 y X
            let rand = arc4random_uniform(UInt32(shotProb))
            return a ? rand == 0 : rand != 0
        }
        return false
    }
}
