//
//  PKRigidBody.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-10.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


public class PKRigidBody: PKBRigidBody {
    
    public init(type: PKRigidBodyType, shape: PKCollisionShape) {
        super.init(collisionShape: shape.internalShape, rigidBodyType: PKBRigidBodyTypeDynamic, mass: type.mass)
    }
    
}
