//
//  PKRaycastResult.swift
//  PhysicsKit
//
//  Created by Adam Eisfeld on 2020-07-03.
//  Copyright © 2020 adameisfeld. All rights reserved.
//

import Foundation

/// Represents a result from a physics world raycast call
public class PKRaycastResult {

    /// The rigid body that intersected the ray
    public weak var rigidBody: PKRigidBody?
    
    /// The world position of the intersection
    public let worldPosition: PKVector3
    
    /// The world normal of the intersection
    public let worldNormal: PKVector3
    
    public init(rigidBody: PKRigidBody, worldPosition: PKVector3, worldNormal: PKVector3) {
        self.rigidBody = rigidBody
        self.worldPosition = worldPosition
        self.worldNormal = worldNormal
    }
    
}
