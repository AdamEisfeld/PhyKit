//
//  PKCollisionPair.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-11.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation
import SceneKit


public class PKCollisionPair {
    
    public let rigidBodyA: PKRigidBody
    public let localPositionA: SCNVector3
    
    public let rigidBodyB: PKRigidBody
    public let localPositionB: SCNVector3
    
    public init(rigidBodyA: PKRigidBody, localPositionA: SCNVector3, rigidBodyB: PKRigidBody, localPositionB: SCNVector3) {
        self.rigidBodyA = rigidBodyA
        self.localPositionA = localPositionA
        self.rigidBodyB = rigidBodyB
        self.localPositionB = localPositionB
    }
    
}
