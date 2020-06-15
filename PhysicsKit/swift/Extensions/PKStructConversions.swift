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
        return SCNVector3(x, y, z)
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
    
}

public extension SCNVector3 {
    
    var PKVector3: PKVector3 {
        return .vector(x, y, z)
    }
    
}

public enum PKRotationMetric {
    case radians
    case degrees
}

public extension PKQuaternion {
    
    var scnQuaternion: SCNQuaternion {
        return SCNQuaternion(x, y, z, w)
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
        return .quaternion(x, y, z, w)
    }
    
}

public extension PKMatrix4 {
    
    var scnMatrix: SCNMatrix4 {
        return SCNMatrix4(m11: m11, m12: m12, m13: m13, m14: m14,
                          m21: m21, m22: m22, m23: m23, m24: m24,
                          m31: m31, m32: m32, m33: m33, m34: m34,
                          m41: m41, m42: m42, m43: m43, m44: m44)
    }
    
}

public extension SCNMatrix4 {
    
    var blMatrix: PKMatrix4 {
        return PKMatrix4Make(m11, m12, m13, m14,
                            m21, m22, m23, m24,
                            m31, m32, m33, m34,
                            m41, m42, m43, m44)
    }
    
}
