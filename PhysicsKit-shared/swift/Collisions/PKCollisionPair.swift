//
//  PKCollisionPair.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-11.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// Represents a pair of rigid bodies that have collided in the simulation
public class PKCollisionPair {
    
    /// The first rigid body that has collided
    public weak var rigidBodyA: PKRigidBody?
    
    /// The position, local to the first rigid body's transform, that the collision occured
    public let localPositionA: PKVector3
    
    /// The second rigid body that has collided
    public weak var rigidBodyB: PKRigidBody?
    
    /// The position, local to the second rigid body's transform, that the collision occured
    public let localPositionB: PKVector3
    
    public init(rigidBodyA: PKRigidBody, localPositionA: PKVector3, rigidBodyB: PKRigidBody, localPositionB: PKVector3) {
        self.rigidBodyA = rigidBodyA
        self.localPositionA = localPositionA
        self.rigidBodyB = rigidBodyB
        self.localPositionB = localPositionB
    }
    
}
