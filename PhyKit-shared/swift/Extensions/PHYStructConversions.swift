//
//  PHYStructConversions.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation
import SceneKit

public extension PHYVector3 {
    
    var scnVector3: SCNVector3 {
        return SCNVector3(PHYSCNFloat(x), PHYSCNFloat(y), PHYSCNFloat(z))
    }
    
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.init(x: x, y: y, z: z)
    }
    
    static var zero: PHYVector3 {
        return PHYVector3(0,0,0)
    }
    
    static func vector(_ x: Float, _ y: Float, _ z: Float) -> PHYVector3 {
        return PHYVector3(x, y, z)
    }
    
    static func radians(_ x: Float, _ y: Float, _ z: Float) -> PHYVector3 {
        return PHYVector3(x, y, z)
    }
    
    static func degrees(_ x: Float, _ y: Float, _ z: Float) -> PHYVector3 {
        return PHYVector3(x, y, z)
    }
    
    static func radiansFromDegrees(_ x: Float, _ y: Float, _ z: Float) -> PHYVector3 {
        return .vector(x * .pi / 180, y * .pi / 180, z * .pi / 180)
    }
    
    static func degreesFromRadians(_ x: Float, _ y: Float, _ z: Float) -> PHYVector3 {
        return .vector(x * 180 / .pi, y * 180 / .pi, z * 180 / .pi)
    }
    
    func toRadians() -> PHYVector3 {
        return .vector(x * .pi / 180, y * .pi / 180, z * .pi / 180)
    }
    
    func toDegrees() -> PHYVector3 {
        return .vector(x * 180 / .pi, y * 180 / .pi, z * 180 / .pi)
    }
    
}

public extension PHYVector4 {
    
    init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.init(x: x, y: y, z: z, w: w)
    }
    
    static func vector(_ x: Float, _ y: Float, _ z: Float, _ w: Float) -> PHYVector4 {
        return PHYVector4(x, y, z, w)
    }
    
}

public extension SCNVector3 {
    
    var bkVector3: PHYVector3 {
        return .vector(Float(x), Float(y), Float(z))
    }
    
}

public extension SCNVector4 {
    
    var PHYVector4: PHYVector4 {
        return .vector(Float(x), Float(y), Float(z), Float(w))
    }
    
}

public enum PHYRotationMetric {
    case radians
    case degrees
}

public extension PHYQuaternion {
    
    var scnQuaternion: SCNQuaternion {
        return SCNQuaternion(PHYSCNFloat(x), PHYSCNFloat(y), PHYSCNFloat(z), PHYSCNFloat(w))
    }

    var direction: PHYVector3 {
        return PHYVector3AxisFromQuaternion(self)
    }
    
    init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.init(x: x, y: y, z: z, w: w)
    }
    
    static func quaternion(_ x: Float, _ y: Float, _ z: Float, _ w: Float) -> PHYQuaternion {
        return PHYQuaternion(x, y, z, w)
    }
    
    static func euler(_ eulerX: Float, _ eulerY: Float, _ eulerZ: Float, _ metric: PHYRotationMetric = .degrees) -> PHYQuaternion {
        
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
        
        return PHYQuaternion(x: x, y: y, z: z, w: w)
    }
    
    static var identity: PHYQuaternion {
        return PHYQuaternionMakeIdentity()
    }
    
}

public extension SCNQuaternion {
    
    var PHYQuaternion: PHYQuaternion {
        return .quaternion(Float(x), Float(y), Float(z), Float(w))
    }
    
}

public extension PHYMatrix4 {
    
    var scnMatrix: SCNMatrix4 {
        
        return SCNMatrix4(m11: PHYSCNFloat(m11), m12: PHYSCNFloat(m12), m13: PHYSCNFloat(m13), m14: PHYSCNFloat(m14),
                          m21: PHYSCNFloat(m21), m22: PHYSCNFloat(m22), m23: PHYSCNFloat(m23), m24: PHYSCNFloat(m24),
                          m31: PHYSCNFloat(m31), m32: PHYSCNFloat(m32), m33: PHYSCNFloat(m33), m34: PHYSCNFloat(m34),
                          m41: PHYSCNFloat(m41), m42: PHYSCNFloat(m42), m43: PHYSCNFloat(m43), m44: PHYSCNFloat(m44))
    }
    
}

public extension SCNMatrix4 {
    
    var blMatrix: PHYMatrix4 {
        return PHYMatrix4Make(Float(m11), Float(m12), Float(m13), Float(m14),
                             Float(m21), Float(m22), Float(m23), Float(m24),
                             Float(m31), Float(m32), Float(m33), Float(m34),
                             Float(m41), Float(m42), Float(m43), Float(m44))
    }
    
}
