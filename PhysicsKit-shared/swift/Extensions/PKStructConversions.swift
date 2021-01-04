//
//  PKStructConversions.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation
import SceneKit

public extension PKVector3 {
    
    var scnVector3: SCNVector3 {
        return SCNVector3(PKSCNFloat(x), PKSCNFloat(y), PKSCNFloat(z))
    }
    
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.init(x: x, y: y, z: z)
    }
    
    static var zero: PKVector3 {
        return PKVector3(0,0,0)
    }
    
    static func vector(_ x: Float, _ y: Float, _ z: Float) -> PKVector3 {
        return PKVector3(x, y, z)
    }
    
    static func radians(_ x: Float, _ y: Float, _ z: Float) -> PKVector3 {
        return PKVector3(x, y, z)
    }
    
    static func degrees(_ x: Float, _ y: Float, _ z: Float) -> PKVector3 {
        return PKVector3(x, y, z)
    }
    
    static func radiansFromDegrees(_ x: Float, _ y: Float, _ z: Float) -> PKVector3 {
        return .vector(x * .pi / 180, y * .pi / 180, z * .pi / 180)
    }
    
    static func degreesFromRadians(_ x: Float, _ y: Float, _ z: Float) -> PKVector3 {
        return .vector(x * 180 / .pi, y * 180 / .pi, z * 180 / .pi)
    }
    
    func toRadians() -> PKVector3 {
        return .vector(x * .pi / 180, y * .pi / 180, z * .pi / 180)
    }
    
    func toDegrees() -> PKVector3 {
        return .vector(x * 180 / .pi, y * 180 / .pi, z * 180 / .pi)
    }
    
}

public extension PKVector4 {
    
    init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.init(x: x, y: y, z: z, w: w)
    }
    
    static func vector(_ x: Float, _ y: Float, _ z: Float, _ w: Float) -> PKVector4 {
        return PKVector4(x, y, z, w)
    }
    
}

public extension SCNVector3 {
    
    var PKVector3: PKVector3 {
        return .vector(Float(x), Float(y), Float(z))
    }
    
}

public extension SCNVector4 {
    
    var PKVector4: PKVector4 {
        return .vector(Float(x), Float(y), Float(z), Float(w))
    }
    
}

public enum PKRotationMetric {
    case radians
    case degrees
}

public extension PKQuaternion {
    
    var scnQuaternion: SCNQuaternion {
        return SCNQuaternion(PKSCNFloat(x), PKSCNFloat(y), PKSCNFloat(z), PKSCNFloat(w))
    }

    var direction: PKVector3 {
        return PKVector3AxisFromQuaternion(self)
    }
    
    init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.init(x: x, y: y, z: z, w: w)
    }
    
    static func quaternion(_ x: Float, _ y: Float, _ z: Float, _ w: Float) -> PKQuaternion {
        return PKQuaternion(x, y, z, w)
    }
    
    static func euler(_ eulerX: Float, _ eulerY: Float, _ eulerZ: Float, _ metric: PKRotationMetric = .degrees) -> PKQuaternion {
        
        let radians = metric == .radians
        let heading = radians ? eulerY : eulerY * .pi / 180
        let attitude = radians ? eulerZ : eulerZ * .pi / 180
        let bank = radians ? eulerX : eulerX * .pi / 180
        
        let c1 = cos(heading / 2)
        let s1 = sin(heading / 2)
        
        let c2 = cos(attitude / 2)
        let s2 = sin(attitude / 2)
        
        let c3 = cos(bank / 2)
        let s3 = sin(bank / 2)
        
        let c1c2 = c1 * c2
        let s1s2 = s1 * s2
        
        let x = c1c2 * s3 - s1s2 * c3
        let y = s1 * c2 * c3 + c1 * s2 * s3
        let z = c1 * s2 * c3 - s1 * c2 * s3
        let w = c1c2 * c3 - s1s2 * s3
        
        return PKQuaternion(x: x, y: y, z: z, w: w)
    }
    
    static var identity: PKQuaternion {
        return PKQuaternionMakeIdentity()
    }
    
}

public extension SCNQuaternion {
    
    var PKQuaternion: PKQuaternion {
        return .quaternion(Float(x), Float(y), Float(z), Float(w))
    }
    
}

public extension PKMatrix4 {
    
    var scnMatrix: SCNMatrix4 {
        
        return SCNMatrix4(m11: PKSCNFloat(m11), m12: PKSCNFloat(m12), m13: PKSCNFloat(m13), m14: PKSCNFloat(m14),
                          m21: PKSCNFloat(m21), m22: PKSCNFloat(m22), m23: PKSCNFloat(m23), m24: PKSCNFloat(m24),
                          m31: PKSCNFloat(m31), m32: PKSCNFloat(m32), m33: PKSCNFloat(m33), m34: PKSCNFloat(m34),
                          m41: PKSCNFloat(m41), m42: PKSCNFloat(m42), m43: PKSCNFloat(m43), m44: PKSCNFloat(m44))
    }
    
}

public extension SCNMatrix4 {
    
    var blMatrix: PKMatrix4 {
        return PKMatrix4Make(Float(m11), Float(m12), Float(m13), Float(m14),
                             Float(m21), Float(m22), Float(m23), Float(m24),
                             Float(m31), Float(m32), Float(m33), Float(m34),
                             Float(m41), Float(m42), Float(m43), Float(m44))
    }
    
}
