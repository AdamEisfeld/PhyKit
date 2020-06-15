//
//  PKTrigger.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

public class PKTrigger: PKBPhysicsTrigger {
    
    public init(shape: PKCollisionShape) {
        super.init(collisionShape: shape.internalShape)
    }
    
    public func getCollidingRigidBodies() -> [PKRigidBody] {
        return internalGetCollidingRigidBodies().map{ (internalRigidBody) -> PKRigidBody? in
            return internalRigidBody as? PKRigidBody
        }.compactMap({$0})
    }
    
}
