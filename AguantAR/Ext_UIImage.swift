//
//  Ext_UIImage.swift
//  AguantAR
//
//  Created by Jesus M Martínez de Juan on 28/5/18.
//  Copyright © 2018 CHECHU. All rights reserved.
//

import UIKit

// PROBABLEMENTE SEA PRESCINDIBLE, ASI QUE LA COMENTO PARA SI EN UN FUTURO NO HAY ERRORES BORRARLO
extension UIImage {
    
//    func tintWithColor(color:UIColor)->UIImage {
//
//        UIGraphicsBeginImageContext(self.size)
//        guard let context = UIGraphicsGetCurrentContext() else { return self }
//
//        // Da forma a la imagen
//        context.scaleBy(x: 1.0, y: -1.0)
//        context.translateBy(x: 0.0,y: -self.size.height)
//
//        // multiply blend mode
//        context.setBlendMode(.multiply)
//
//        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
//        context.clip(to: rect, mask: self.cgImage!)
//        color.setFill()
//        context.fill(rect)
//
//        // create uiimage
//        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
//        UIGraphicsEndImageContext()
//
//        return newImage
//
//    }
}
