//
//  PHYAction+Move.swift
//  PhyKit
//
//  Created by Adam Eisfeld on 2020-07-03.
//  Copyright © 2020 adameisfeld. All rights reserved.
//

import Foundation

/// Helper actions for moving rigid bodies
public extension PHYAction {

    static func move(_ rigidBody: PHYRigidBody, to end: PHYVector3, duration: TimeInterval) -> PHYAction {

        return PHYAction(rigidBody: rigidBody, duration: duration, setup: { (rigidBody) -> (Any?) in
            
            return rigidBody.position
            
        }) { (percent, rigidBody, setupInfo) in
            
            guard let startingPosition = setupInfo as? PHYVector3 else { return }
            let dist: PHYVector3 = .vector(end.x - startingPosition.x, end.y - startingPosition.y, end.z - startingPosition.z)
            let deltaX = dist.x * Float(percent)
            let deltaY = dist.y * Float(percent)
            let deltaZ = dist.z * Float(percent)
            rigidBody.position = .vector(startingPosition.x + deltaX, startingPosition.y + deltaY, startingPosition.z + deltaZ)
            
        }
        
    }
    
    static func move(_ rigidBody: PHYRigidBody, by dist: PHYVector3, duration: TimeInterval) -> PHYAction {

        return PHYAction(rigidBody: rigidBody, duration: duration, setup: { (rigidBody) -> (Any?) in
            
            return rigidBody.position
            
        }) { (percent, rigidBody, setupInfo) in
            
            guard let startingPosition = setupInfo as? PHYVector3 else { return }
            let deltaX = dist.x * Float(percent)
            let deltaY = dist.y * Float(percent)
            let deltaZ = dist.z * Float(percent)
            rigidBody.position = .vector(startingPosition.x + deltaX, startingPosition.y + deltaY, startingPosition.z + deltaZ)
            
        }

    }
    
    static func move(_ rigidBody: PHYRigidBody, byFunction distFunction: @escaping ()->(PHYVector3)) -> PHYAction {

        return PHYAction(rigidBody: rigidBody, duration: 1.0, setup: { (rigidBody) -> (Any?) in
            
            return nil
            
        }) { (percent, rigidBody, setupInfo) in

            let startingPosition = rigidBody.position
            let delta = distFunction()
            rigidBody.position = .vector(startingPosition.x + delta.x, startingPosition.y + delta.y, startingPosition.z + delta.z)
            
        }

    }

}
