//
//  PHYRaycastResult.swift
//  PhyKit
//
//  Created by Adam Eisfeld on 2020-07-03.
//  Copyright © 2020 adameisfeld. All rights reserved.
//

import Foundation

/// Represents a result from a physics world raycast call
public class PHYRaycastResult {

    /// The rigid body that intersected the ray
    public weak var rigidBody: PHYRigidBody?
    
    /// The world position of the intersection
    public let worldPosition: PHYVector3
    
    /// The world normal of the intersection
    public let worldNormal: PHYVector3
    
    public init(rigidBody: PHYRigidBody, worldPosition: PHYVector3, worldNormal: PHYVector3) {
        self.rigidBody = rigidBody
        self.worldPosition = worldPosition
        self.worldNormal = worldNormal
    }
    
}
