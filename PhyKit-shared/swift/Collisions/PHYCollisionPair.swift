//
//  PHYCollisionPair.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-11.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// Represents a pair of rigid bodies that have collided in the simulation
public class PHYCollisionPair {
    
    /// The first rigid body that has collided
    public weak var rigidBodyA: PHYRigidBody?
    
    /// The position, local to the first rigid body's transform, that the collision occured
    public let localPositionA: PHYVector3
    
    /// The second rigid body that has collided
    public weak var rigidBodyB: PHYRigidBody?
    
    /// The position, local to the second rigid body's transform, that the collision occured
    public let localPositionB: PHYVector3
    
    public init(rigidBodyA: PHYRigidBody, localPositionA: PHYVector3, rigidBodyB: PHYRigidBody, localPositionB: PHYVector3) {
        self.rigidBodyA = rigidBodyA
        self.localPositionA = localPositionA
        self.rigidBodyB = rigidBodyB
        self.localPositionB = localPositionB
    }
    
}
