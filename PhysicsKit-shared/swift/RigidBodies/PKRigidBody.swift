//
//  PKRigidBody.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-10.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


/// RigidBody instances are attached to PhysicsWorlds to represent a rigid body in the simulation.
public class PKRigidBody: PKBRigidBody {
    
    /// A unique identifier for this rigid body, used internally
    public let uuid: String = UUID().uuidString
    
    /// The type of this rigid body
    public let type: PKRigidBodyType
    
    /// Creates a new rigid body
    /// - Parameters:
    ///   - type: The type of rigid body to create
    ///   - shape: The shape to use for collision detections for this rigid body
    public init(type: PKRigidBodyType, shape: PKCollisionShape) {
        self.type = type
        super.init(collisionShape: shape.internalShape, rigidBodyType: type.internalType, mass: type.mass)
    }
    
}
