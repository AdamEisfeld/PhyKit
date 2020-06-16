//
//  PKTrigger.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// Trigger instances are attached to PhysicsWorlds to represent a geometric shape that a RigidBody can enter/exit to trigger additional logic
public class PKTrigger: PKBPhysicsTrigger {
    
    /// A unique identifier for this trigger, used internally
    public let uuid: String = UUID().uuidString
    
    /// Creates a new trigger
    /// - Parameter shape: The shape to use for detecting rigid body intersections with this trigger
    public init(shape: PKCollisionShape) {
        super.init(collisionShape: shape.internalShape)
    }
    
    /// Calculates which rigid bodies are currently intersecting this trigger
    /// - Returns: An array of RigidBody instances intersecting this trigger in the current simulation
    public func getCollidingRigidBodies() -> [PKRigidBody] {
        return internalGetCollidingRigidBodies().map{ (internalRigidBody) -> PKRigidBody? in
            return internalRigidBody as? PKRigidBody
        }.compactMap({$0})
    }
    
}
