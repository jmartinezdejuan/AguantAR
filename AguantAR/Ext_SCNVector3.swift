//
//  Ext_SCNVector3.swift
//  AguantAR
//
//  Created by Jesus M Martínez de Juan on 28/5/18.
//  Copyright © 2018 CHECHU. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3{
    
    /**
     * Niega = da valor negativo
     */
    /**
     * Niega el vector descrito por SCNVector3 y devuelve el resultado como un nuevo SCNVector3
     */
    func negate() -> SCNVector3 {
        return self * -1
    }
    
    /**
     * Niega el vector descrito por SCNVector3
     */
    mutating func negated() -> SCNVector3 {
        self = negate()
        return self
    }
    
    /**
     * Devuelve la longitud (magnitud) del vector descrito por el SCNVector3
     */
    func length() -> Float {
        return sqrtf(x*x + y*y + z*z)
    }
    
    func xzLength() -> Float {
        return sqrtf(x*x + z*z)
    }
    
    /**
     * Normaliza el vector descrito por el SCNVector3 a una altura de 1.0 y devuelve el resultado
     * como un vector SCNVector3
     */
    func normalized() -> SCNVector3 {
        return self / length()
    }
    
    /**
     * Normaliza el vector descrito por el SCNVector3 a una altura de 1.0
     */
    mutating func normalize() -> SCNVector3 {
        self = normalized()
        return self
    }
    /**
     * Ordena en coordenadas x,y,z dandole un formato de tipo Float (%f) y cogiendo
     * dos decimales (.2). Por lo que para formatear se queda con %.2f
     */
    func shortened() -> String {
        return "[\(String(format: "%.2f", self.x)),\(String(format: "%.2f", self.y)),\(String(format: "%.2f", self.z))]"
    }
    
    /**
     * Calcula la distancia entre 2 vectores SCNVector3 aplicando el teorema de Pitágoras
     */
    func distance(vector: SCNVector3) -> Float {
        return (self - vector).length()
    }
    
    /**
     * Calcula el producto ESCALAR entre dos SCNVector3
     */
    func dot(vector: SCNVector3) -> Float {
        return x * vector.x + y * vector.y + z * vector.z
    }
    
    /**
     * Calcula el producto VECTORIAL entre dos SCNVector3
     */
    func cross(vector: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(y * vector.z - z * vector.y, z * vector.x - x * vector.z, x * vector.y - y * vector.x)
    }
}

/**
 * Compara si dos SCNVector3 son iguales comparando por cada elemento
 */
func == (left: SCNVector3, right: SCNVector3) -> Bool{
    return (left.x == right.x && left.y == right.y && left.z == right.z)
}

/**
 * Compara si dos SCNVector3 NO son iguales comparando por cada elemento
 */
func != (left: SCNVector3, right: SCNVector3) -> Bool{
    return (left.x != right.x || left.y != right.y || left.z != right.z)
}

/**
 * Suma dos SCNVector3 y devuelve el resultado como uno nuevo
 */
func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

/**
 * Incrementa un SCNVector3 con el valor de otro
 */
func += ( left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}

/**
 * Resta dos SCNVector3 y devuelve el resultado como uno nuevo
 */
func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

/**
 * Decrementa un SCNVector3 con el valor de otro
 */
func -= ( left: inout SCNVector3, right: SCNVector3) {
    left = left - right
}

/**
 * Multiplica dos SCNVector3 y devuelve el resultado como uno nuevo
 */
func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

/**
 * Multiplica un SCNVector3 por otro
 */
func *= ( left: inout SCNVector3, right: SCNVector3) {
    left = left * right
}

/**
 * Multiplica los campos x,y,z de un SCNVector3 por el mismo valor escalar y
 * devuelve el resultado como uno nuevo
 */
func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
}

/**
 * Multiplica los campos x,y,z de un SCNVector3 por el mismo valor escalar
 */
func *= ( vector: inout SCNVector3, scalar: Float) {
    vector = vector * scalar
}

/**
 * Divide dos SCNVector3 y devuelve el resultado como uno nuevo
 */
func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

/**
 * Divide un SCNVector3 entre otro
 */
func /= ( left: inout SCNVector3, right: SCNVector3) {
    left = left / right
}

/**
 * Divide los campos x,y,z de un SCNVector3 entre el mismo valor escalar y
 * devuelve el resultado como uno nuevo
 */
func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
}

/**
 * Divide los campos x,y,z de un SCNVector3 entre el mismo valor escalar
 */
func /= ( vector: inout SCNVector3, scalar: Float) {
    vector = vector / scalar
}

/**
 * Niega un vector
 */
func SCNVector3Negate(vector: SCNVector3) -> SCNVector3 {
    return vector * -1
}

/**
 * Devuelve la longitud (magnitud) del vector descrito por el SCNVector3
 */
func SCNVector3Length(vector: SCNVector3) -> Float
{
    return sqrtf(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z)
}

/**
 * Devuelve la distancia entre 2 vectores SCNVector3
 */
func SCNVector3Distance(vectorStart: SCNVector3, vectorEnd: SCNVector3) -> Float {
    return SCNVector3Length(vector: vectorEnd - vectorStart)
}

/**
 * Devuelve la normalizacion de un vector
 */
func SCNVector3Normalize(vector: SCNVector3) -> SCNVector3 {
    return vector / SCNVector3Length(vector: vector)
}

/**
 * Calcula el producto ESCALAR entre dos SCNVector3
 */
func SCNVector3DotProduct(left: SCNVector3, right: SCNVector3) -> Float {
    return left.x * right.x + left.y * right.y + left.z * right.z
}

/**
 * Calcula el producto VECTORIAL entre dos SCNVector3
 */
func SCNVector3CrossProduct(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.y * right.z - left.z * right.y, left.z * right.x - left.x * right.z, left.x * right.y - left.y * right.x)
}

/**
 * Calcula el SCNVector3 resultante de la interpolación lineal entre dos SCNVector3
 */
func SCNVector3Lerp(vectorStart: SCNVector3, vectorEnd: SCNVector3, t: Float) -> SCNVector3 {
    return SCNVector3Make(vectorStart.x + ((vectorEnd.x - vectorStart.x) * t), vectorStart.y + ((vectorEnd.y - vectorStart.y) * t), vectorStart.z + ((vectorEnd.z - vectorStart.z) * t))
}

/**
 * Proyecta el vector vectorToProject sobre el vector projectionVector
 */
func SCNVector3Project(vectorToProject: SCNVector3, projectionVector: SCNVector3) -> SCNVector3 {
    let scale: Float = SCNVector3DotProduct(left: projectionVector, right: vectorToProject) / SCNVector3DotProduct(left: projectionVector, right: projectionVector)
    let v: SCNVector3 = projectionVector * scale
    return v
    
}
