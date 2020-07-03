//
//  PKAction+Orient.swift
//  PhysicsKit
//
//  Created by Adam Eisfeld on 2020-07-03.
//  Copyright © 2020 adameisfeld. All rights reserved.
//

import Foundation

/// Helper actions for orienting rigid bodies
public extension PKAction {

    static func orient(_ rigidBody: PKRigidBody, by delta: PKQuaternion, duration: TimeInterval, longestArc: Bool = false) -> PKAction {
    
        return PKAction(rigidBody: rigidBody, duration: duration, setup: { (rigidBody) -> (Any?) in

            let svStart = simd_make_float4(rigidBody.orientation.x, rigidBody.orientation.y, rigidBody.orientation.z, rigidBody.orientation.w)
            let svChange = simd_make_float4(delta.x, delta.y, delta.z, delta.w)
            
            let sStart = simd_quatf(vector: svStart)
            let sChange = simd_quatf(vector: svChange)
            let sEnd = simd_mul(sStart, sChange)
            
            return [
                "startOrientation" : sStart,
                "endOrientation" : sEnd
            ]
            
        }) { (percent, rigidBody, setupInfo) in
            
            guard let setupInfo = setupInfo as? [String : simd_quatf] else { return }
            guard let startOrientation = setupInfo["startOrientation"], let endOrientation = setupInfo["endOrientation"] else { return }
            let sInterpolatedOrientation: simd_quatf
            if !longestArc {
                sInterpolatedOrientation = simd_slerp(startOrientation, endOrientation, Float(percent))
            } else {
                sInterpolatedOrientation = simd_slerp_longest(startOrientation, endOrientation, Float(percent))
            }
                
            let interpolatedOrientation: PKQuaternion = PKQuaternion.quaternion(sInterpolatedOrientation.vector.x, sInterpolatedOrientation.vector.y, sInterpolatedOrientation.vector.z, sInterpolatedOrientation.vector.w)
            rigidBody.orientation = interpolatedOrientation
            
        }
    
    }
    
    static func orient(_ rigidBody: PKRigidBody, to end: PKQuaternion, duration: TimeInterval, longestArc: Bool = false) -> PKAction {
        
        return PKAction(rigidBody: rigidBody, duration: duration, setup: { (rigidBody) -> (Any?) in
            
            let start = rigidBody.orientation
            let svStart = simd_make_float4(start.x, start.y, start.z, start.w)
            let svEnd = simd_make_float4(end.x, end.y, end.z, end.w)
            let sStart = simd_quatf(vector: svStart)
            let sEnd = simd_quatf(vector: svEnd)
            
            return [
                "startOrientation" : sStart,
                "endOrientation" : sEnd
            ]
            
        }) { (percent, rigidBody, setupInfo) in
            
            guard let setupInfo = setupInfo as? [String : simd_quatf] else { return }
            guard let startOrientation = setupInfo["startOrientation"], let endOrientation = setupInfo["endOrientation"] else { return }
            
            let sInterpolatedOrientation: simd_quatf
            if !longestArc {
                sInterpolatedOrientation = simd_slerp(startOrientation, endOrientation, Float(percent))
            } else {
                sInterpolatedOrientation = simd_slerp_longest(startOrientation, endOrientation, Float(percent))
            }
            
            let interpolatedOrientation: PKQuaternion = PKQuaternion.quaternion(sInterpolatedOrientation.vector.x, sInterpolatedOrientation.vector.y, sInterpolatedOrientation.vector.z, sInterpolatedOrientation.vector.w)
            rigidBody.orientation = interpolatedOrientation
            
        }
        
    }
    
    

}
